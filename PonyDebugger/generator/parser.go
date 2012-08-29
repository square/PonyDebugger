package main

import (
    "io"
    "os"
    "strings"
    "text/template"
    "fmt"
    "time"
)

var TypeLookup map[string]string = map[string]string{
    "any":     "id ",
    "string":  "NSString *",
    "integer": "NSNumber *",
    "number":  "NSNumber *",
    "boolean": "NSNumber *",
    "array":   "NSArray *",
    "object":  "NSDictionary *",
}

var AttributeTypeLookup map[string]string = map[string]string{
    "any":     "NSTransformableAttributeType",
    "string":  "NSStringAttributeType",
    "integer": "NSInteger64AttributeType",
    "number":  "NSDoubleAttributeType",
    "boolean": "NSBooleanAttributeType",
    "array":   "NSTransformableAttributeType",
    "object":  "NSTransformableAttributeType",
}

var PropertyNameMappings map[string]string = map[string]string{
    "id":          "identifier",
    "description": "objectDescription",
    "deleted":     "objectDeleted",
    "className":   "classNameString",
}

func MapPropertyName(origName string) string {
    newName, found := PropertyNameMappings[origName]

    if found {
        return newName
    }

    return origName
}

func (s *SchemaDomain) CurDate() (date string) {
    time := time.Now()
    return time.Format("1/2/06")
}

func QualifyName(domainName string, refString string) (typeDomain string, typeId string) {
    splittedRef := strings.Split(refString, ".")

    typeId = splittedRef[len(splittedRef)-1]

    if len(splittedRef) == 2 {
        typeDomain = splittedRef[0]
    } else {
        typeDomain = domainName
    }

    return
}

func (s *SchemaType) ResolveType() *SchemaType {
    if s.Ref != "" {
        domain, typeId := QualifyName(s.domain.Name, s.Ref)
        return s.domain.root.domainsByName[domain].typesById[typeId].ResolveType()
    }
    return s
}

func (s *SchemaType) EntityName() string {
    return s.domain.Name + s.Id
}

func (s *SchemaType) ClassName() string {
    return Prefix + s.EntityName()
}

func (s *SchemaType) PropertyName() (name string) {
    return MapPropertyName(s.Name)
}

func (s *SchemaType) PropertyType() (typeString string) {
    t := s.ResolveType()

    if t.IsClass() {
        typeString = t.ClassName() + " *"
    } else {
        var found bool
        typeString, found = TypeLookup[t.Type]
        if !found {
            panic("Type " + t.Type + " in " + t.Id + " Not found")
        }
    }
    return
}

func (s *SchemaType) AttributeType() (typeString string) {
    if s.IsClass() {
        panic("Can only be called by attributes, not refs")
    }

    return AttributeTypeLookup[s.ResolveType().Type]
}


func (s *SchemaCommand) IsNotSpecial() bool {
    return s.Name != "disable" && s.Name != "enable"
}

func (s *SchemaCommand) ReturnsCallbackType() string {
    args := make([]string, len(s.Returns) + 1)

    for i, r := range s.Returns {
        args[i] = r.PropertyType() + r.PropertyName()
    }

    args[len(args) - 1] = "id error"

    return "void (^)(" + strings.Join(args, ", ") + ")"
}


func (s *SchemaCommand) ReturnsCallbackSignature() string {
    args := make([]string, len(s.Returns) + 1)

    for i, r := range s.Returns {
        args[i] = r.PropertyType() + r.PropertyName()
    }

    args[len(args) - 1] = "id error"

    return "^(" + strings.Join(args, ", ") + ")"
}

// This method is gross.  SHould be done with templating
func (s *SchemaCommand) ReturnsCallbackWrapper() (ret string) {
    ret = s.ReturnsCallbackSignature() + " {"

    if len(s.Returns) > 0 {
        ret += fmt.Sprintf(`
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:%d];

`, len(s.Returns))

        for _, p := range s.Returns {
            ret += "            if (" + p.PropertyName() + ` != nil) {
                [params setObject:` + p.PropertyName() + ` forKey:@"` + p.Name + `"];
            }
`
        }
        ret += `
            responseCallback(params, error);
        }`
    } else {
        ret += `
            responseCallback(nil, error);
        }`
    }
    return
}


type SelectorPart struct {
    partName string
    argName string
    typeName string
    arg string
}

type Method struct {
    parts []SelectorPart
    returnType string
}

func (m *Method) Selector() (ret string) {
    ret = "@selector("

    for _, part := range m.parts {
        ret += part.partName
    }

    ret += ")"

    return
}

func (m *Method) Signature() (ret string) {
    ret = "- (" + m.returnType + ")"

    for i, part := range m.parts {
        ret += part.partName + "(" + part.typeName + ")" + part.argName
        if i != len(m.parts) - 1 {
            ret += " "
        }
    }

    return
}

func (m *Method) CallFromDict(receiver string) (ret string) {
    ret = "[" + receiver + " "

    for i, part := range m.parts {
        ret += part.partName + part.arg
        if i != len(m.parts) - 1 {
            ret += " "
        }
    }

    ret += "]"

    return
}

func (s *SchemaCommand) DelegateMethod() (ret *Method) {

    ret = &Method{make([]SelectorPart, len(s.Parameters) + 2), "void"}


    ret.parts[0] = SelectorPart{"domain:", "domain", s.domain.ClassName() + " *", "self"}

    for i, p := range s.Parameters {
        segmentName := p.Name
        if i == 0 {
            segmentName = s.Name + "With" + strings.ToUpper(segmentName[:1]) + segmentName[1:]
        }

        ret.parts[i + 1] = SelectorPart{segmentName + ":", p.PropertyName(), p.PropertyType(), `[params objectForKey:@"` + p.Name + `"]`}
    }


    callbackPart := "callback:"

    if len(s.Parameters) == 0 {
        callbackPart = s.Name + "WithCallback:"
    }
    ret.parts[len(ret.parts) - 1] = SelectorPart{callbackPart, "callback", s.ReturnsCallbackType(), s.ReturnsCallbackWrapper()}

    return
}

func (s *SchemaEvent) Signature() string {
    ret := "- (void)" + s.Name
    for i, p := range s.Parameters {
        segmentName := p.Name
        if i == 0 {
            segmentName = "With" + strings.ToUpper(segmentName[:1]) + segmentName[1:]
        }

        ret += segmentName + ":(" + p.PropertyType() + ")" + p.PropertyName()

        if i != len(s.Parameters) - 1 {
            ret += " "
        }
    }
    return ret
}

func (s *SchemaEvent) QualifiedName() string {
    return s.domain.Name + "." + s.Name
}

func (s *SchemaType) IsClass() bool {
    return (s.Type == "object" || s.Type == "") && len(s.Properties) > 0
}

// Things we need to forward declare
func (s *SchemaType) ClassDependencies() (deps []string) {
    dependencies := make(map[string]int)

    for _, p := range s.Properties {
        t := p.ResolveType()
        if t.IsClass() {
            dependencies[t.ClassName()] = 1
        }
    }

    deps = make([]string, len(dependencies))

    i := 0
    for d := range dependencies {
        deps[i] = d
        i++
    }

    return
}

func (s *SchemaDomain) HasEvents() bool {
    return len(s.Events) > 0
}

func (s *SchemaDomain) HasCommands() bool {
    return len(s.Commands) > 0
}

func (s *SchemaDomain) HasClasses() bool {
    for _, t := range s.Types {
        if t.IsClass() {
            return true
        }
    }

    return false
}

func (s *SchemaDomain) Classes() []*SchemaType {
    ret := make([]*SchemaType, 0, len(s.Types))
    for _, t := range s.Types {
        if !t.IsClass() {
            continue
        }

        ret = append(ret, t)
    }

    return ret
}

func (s *SchemaDomain) NeededForwardDeclarationsForType() (deps []string) {
    seen := make(map[string]int, len(s.Types))

    needed := make(map[string]int)

    for _, t := range s.Types {
        if !t.IsClass() {
            continue
        }
        seen[t.ClassName()] = 1

        for _, dep := range t.ClassDependencies() {
            if _, found := seen[dep]; !found {
                needed[dep] = 1
            }
        }
    }

    deps = make([]string, len(needed))

    i := 0
    for d := range needed {
        deps[i] = d
        i++
    }

    return
}

func (s *SchemaDomain) NeededForwardDeclarationsForEvents() (deps []string) {
    needed := make(map[string]int)

    for _, e := range s.Events {
        for _, p := range e.Parameters {
            t := p.ResolveType()
            if !t.IsClass() {
                continue
            }

            needed[t.ClassName()] = 1
        }
    }
    for _, e := range s.Commands {
        for _, p := range append(e.Parameters, e.Returns...) {
            t := p.ResolveType()
            if !t.IsClass() {
                continue
            }

            needed[t.ClassName()] = 1
        }
    }

    deps = make([]string, len(needed))

    i := 0
    for d := range needed {
        deps[i] = d
        i++
    }

    return
}

func (s *SchemaDomain) NeededImportsForEvents() (deps []string) {
    needed := make(map[string]int)

    for _, e := range s.Events {
        for _, p := range e.Parameters {
            t := p.ResolveType()
            if !t.IsClass() {
                continue
            }

            needed[t.domain.TypesFileName()] = 1
        }
    }
    for _, e := range s.Commands {
        for _, p := range append(e.Parameters, e.Returns...) {
            t := p.ResolveType()
            if !t.IsClass() {
                continue
            }

            needed[t.domain.TypesFileName()] = 1
        }
    }

    deps = make([]string, len(needed))

    i := 0
    for d := range needed {
        deps[i] = d
        i++
    }

    return
}



func (s *SchemaDomain) CommandDelegateName() string {
    return Prefix + s.Name + "CommandDelegate"
}

func (s *SchemaDomain) ClassName() string {
    return Prefix + s.Name + "Domain"
}

func (s *SchemaDomain) PropertyName() (name string) {
    // Only downcase if second char is downcased
    if strings.ToLower(s.Name[1:2]) == s.Name[1:2] {
        name = strings.ToLower(s.Name[:1]) + s.Name[1:] + "Domain"
    } else {
        name = s.Name + "Domain"
    }

    return
}

func (s *SchemaDomain) TypesFileName() string {
    return Prefix + s.Name + "Types"
}

func (s *SchemaDomain) DomainFileName() string {
    return s.ClassName()
}

func (s *SchemaDomain) WriteTypesHeader(wr io.Writer) {
    tmpl, err := template.New("test").Parse(`//    
//  {{.TypesFileName}}.h
//  PonyDebuggerDerivedSources
//
//  Generated on {{.CurDate}}
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//
    
#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

{{if .NeededForwardDeclarationsForType}}
{{range .NeededForwardDeclarationsForType}}@class {{.}};
{{end}}
{{end}}{{range .Classes}}
{{if .Description}}// {{.Description}}
{{end}}@interface {{.ClassName}} : PDObject
{{range .Properties}}
{{if .Description}}// {{.Description}}
{{end}}{{if .Type}}// Type: {{.Type}}
{{end}}@property (nonatomic, strong) {{.PropertyType}}{{.PropertyName}};
{{end}}
@end

{{end}}
`)
    if err != nil {
        panic(err)
    }

    _ = tmpl
    err = tmpl.Execute(wr, s)
    if err != nil {
        panic(err)
    }
}

func (s *SchemaDomain) WriteTypesImplementation(wr io.Writer) {
    tmpl, err := template.New("test").Parse(`//
//  {{.TypesFileName}}.m
//  PonyDebuggerDerivedSources
//
//  Generated on {{.CurDate}}
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "{{.TypesFileName}}.h"
{{range .Classes}}
{{template "implementation" .}}
{{end}}
`)
    if err != nil {
        panic(err)
    }

    impl, err := tmpl.New("implementation").Parse(`@implementation {{.ClassName}}

{{template "keysToEncode" .}}

{{range .Properties}}@dynamic {{.PropertyName}};
{{end}} 
@end`)

    _, err = impl.New("keysToEncode").Parse(`+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    {{range .Properties}}@"{{.Name}}",@"{{.PropertyName}}",
                    {{end}}nil];
    });

    return mappings;
}`)

    if err != nil {
        panic(err)
    }

    if err = tmpl.Execute(wr, s); err != nil {
        panic(err)
    }
}

func (s *SchemaDomain) WriteDomainHeader(wr io.Writer) {
    tmpl, err := template.New("test").Parse(`//
//  {{.ClassName}}.h
//  PonyDebuggerDerivedSources
//
//  Generated on {{.CurDate}}
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>

{{if .NeededForwardDeclarationsForEvents}}{{range .NeededForwardDeclarationsForEvents}}@class {{.}};
{{end}}{{end}}
@protocol {{.CommandDelegateName}};

{{if .Description}}// {{.Description}}
{{end}}@interface {{.ClassName}} : PDDynamicDebuggerDomain 

@property (nonatomic, assign) id <{{.CommandDelegateName}}, PDCommandDelegate> delegate;
{{if .HasEvents}}
// Events
{{range .Events}}{{if .Description}}
// {{.Description}}
{{end}}{{range .Parameters}}{{if .Description}}// Param {{.Name}}: {{.Description}}
{{end}}{{end}}{{.Signature}};
{{end}}{{end}}
@end

@protocol {{.CommandDelegateName}} <PDCommandDelegate>
@optional
{{range .Commands}}{{if .Description}}
// {{.Description}}
{{end}}{{range .Parameters}}{{if .Description}}// Param {{.Name}}: {{.Description}}
{{end}}{{end}}{{range .Returns}}{{if .Description}}// Callback Param {{.Name}}: {{.Description}}
{{end}}{{end}}{{.DelegateMethod.Signature}};
{{end}}
@end

@interface PDDebugger ({{.ClassName}})

@property (nonatomic, readonly, strong) {{.ClassName}} *{{.PropertyName}};

@end
`)
    if err = tmpl.Execute(wr, s); err != nil {
        panic(err)
    }
}

func (s *SchemaDomain) WriteDomainImplementation(wr io.Writer) {

    tmpl, err := template.New("test").Parse(`//
//  {{.ClassName}}.m
//  PonyDebuggerDerivedSources
//
//  Generated on {{.CurDate}}
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/{{.ClassName}}.h>
#import <PonyDebugger/PDObject.h>
{{if .NeededImportsForEvents}}{{range .NeededImportsForEvents}}#import <PonyDebugger/{{.}}.h>
{{end}}{{end}}

@interface {{.ClassName}} (){{if .HasCommands}}
//Commands
{{end}}
@end

@implementation {{.ClassName}}

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"{{.Name}}";
}
{{if .HasEvents}}
// Events
{{range .Events}}{{if .Description}}
// {{.Description}}
{{end}}{{.Signature}};
{{print "{"}}{{if .Parameters}}
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:{{.Parameters | len}}];

    {{range .Parameters}}if ({{.PropertyName}} != nil) {
        [params setObject:[{{.PropertyName}} PD_JSONObject] forKey:@"{{.Name}}"];
    }
    {{end}}
    [self.debuggingServer sendEventWithName:@"{{.QualifiedName}}" parameters:params];
{{else}}
    [self.debuggingServer sendEventWithName:@"{{.QualifiedName}}" parameters:nil];
{{end}}}
{{end}}{{end}}

{{if .HasCommands}}
- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(PDResponseCallback)responseCallback;
{
    {{range .Commands}}if ([methodName isEqualToString:@"{{.Name}}"] && [self.delegate respondsToSelector:{{.DelegateMethod.Selector}}]) {
        {{.DelegateMethod.CallFromDict "self.delegate"}};
    } else {{end}}{
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}{{end}}

@end


@implementation PDDebugger ({{.ClassName}})

- ({{.ClassName}} *){{.PropertyName}};
{
    return [self domainForName:@"{{.Name}}"];
}

@end
`)
    if err = tmpl.Execute(wr, s); err != nil {
        panic(err)
    }

}

const Prefix = "PD"
const PathPrefix = "../DerivedSources/"

func main() {
    dec := NewSchemaDecoder(os.Stdin)

    root := dec.ReadSchema()

    for _, domain := range root.Domains {
        // Types
        if domain.HasClasses() {
            headerName := (PathPrefix + domain.TypesFileName() + ".h")
            headerFile, _ := os.Create(headerName)
            domain.WriteTypesHeader(headerFile)
            headerFile.Close()

            implementationName := PathPrefix + domain.TypesFileName() + ".m"
            implementationFile, _ := os.Create(implementationName)
            domain.WriteTypesImplementation(implementationFile)
            implementationFile.Close()
        }
    }

    for _, domain := range root.Domains {
        if domain.HasEvents() || domain.HasCommands() {
            headerName := (PathPrefix + domain.DomainFileName() + ".h")
            headerFile, _ := os.Create(headerName)
            domain.WriteDomainHeader(headerFile)

            implementationName := PathPrefix + domain.DomainFileName() + ".m"
            implementationFile, _ := os.Create(implementationName)
            domain.WriteDomainImplementation(implementationFile)
            implementationFile.Close()
        }
    }
}
