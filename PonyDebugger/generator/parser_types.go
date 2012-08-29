package main

import (
    "encoding/json"
    "io"
)

type SchemaRoot struct {
    Domains []*SchemaDomain `json:"domains"`
    Version struct {
        Major string `json:"major"`
        Minor string `json:"minor"`
    }   `json:"version"`

    domainsByName map[string]*SchemaDomain
}

func (s *SchemaRoot) FillInDatas() {
    s.domainsByName = make(map[string]*SchemaDomain, len(s.Domains))
    for _, d := range s.Domains {
        d.FillInData(d)
        d.root = s
        s.domainsByName[d.Name] = d
    }
}

type SchemaBase struct {
    domain *SchemaDomain
}

func (s *SchemaBase) LookupType(domain string, typeId string) *SchemaType {
    return s.domain.root.domainsByName[domain].typesById[typeId]
}

func (s *SchemaBase) FillInData(domain *SchemaDomain) {
    s.domain = domain
}

type SchemaDomain struct {
    SchemaBase
    Description string           `json:"description,omitempty"`
    Hidden      bool             `json:"hidden,omitempty"`
    Name        string           `json:"domain,omitempty"`
    Types       []*SchemaType    `json:"types,omitempty"`
    Commands    []*SchemaCommand `json:"commands,omitempty"`
    Events      []*SchemaEvent   `json:"events,omitempty"`

    typesById      map[string]*SchemaType
    commandsByName map[string]*SchemaCommand
    eventsByName   map[string]*SchemaEvent
    root           *SchemaRoot
}

func (s *SchemaDomain) FillInData(domain *SchemaDomain) {
    s.SchemaBase.FillInData(domain)
    s.commandsByName = make(map[string]*SchemaCommand, len(s.Commands))
    for _, c := range s.Commands {
        c.FillInData(domain)
        s.commandsByName[c.Name] = c
    }

    s.typesById = make(map[string]*SchemaType, len(s.Types))
    for _, c := range s.Types {
        c.FillInData(domain)
        s.typesById[c.Id] = c
    }

    s.eventsByName = make(map[string]*SchemaEvent, len(s.Events))
    for _, c := range s.Events {
        c.FillInData(domain)
        s.eventsByName[c.Name] = c
    }
}

type SchemaType struct {
    SchemaBase
    Description string        `json:"description,omitempty"`
    Hidden      bool          `json:"hidden,omitempty"`
    Id          string        `json:"id,omitempty"`
    Type        string        `json:"type,omitempty"`
    Enum        []string      `json:"enum,omitempty"`
    Properties  []*SchemaType `json:"properties,omitempty"`
    Ref         string        `json:"$ref,omitempty"`
    Name        string        `json:"name,omitempty"`
    Optional    bool          `json:"optional,omitempty"`
    Items       *SchemaType   `json:"items,omitempty"`
}

func (s *SchemaType) FillInData(domain *SchemaDomain) {
    s.SchemaBase.FillInData(domain)

    for _, c := range s.Properties {
        c.FillInData(domain)
    }

    if s.Items != nil {
        s.Items.FillInData(domain)
    }
}

type SchemaCommand struct {
    SchemaBase
    Description string        `json:"description,omitempty"`
    Hidden      bool          `json:"hidden,omitempty"`
    Name        string        `json:"name,omitempty"`
    Parameters  []*SchemaType `json:"parameters,omitempty"`
    Returns     []*SchemaType `json:"returns,omitempty"`
}

func (s *SchemaCommand) FillInData(domain *SchemaDomain) {
    s.SchemaBase.FillInData(domain)

    for _, c := range s.Parameters {
        c.FillInData(domain)
    }

    for _, c := range s.Returns {
        c.FillInData(domain)
    }
}

type SchemaEvent struct {
    SchemaBase
    Description string        `json:"description,omitempty"`
    Hidden      bool          `json:"hidden,omitempty"`
    Name        string        `json:"domain,omitempty"`
    Parameters  []*SchemaType `json:"parameters,omitempty"`
}

func (s *SchemaEvent) FillInData(domain *SchemaDomain) {
    s.SchemaBase.FillInData(domain)

    for _, c := range s.Parameters {
        c.FillInData(domain)
    }
}

type SchemaDecoder struct {
    *json.Decoder
}

func NewSchemaDecoder(r io.Reader) *SchemaDecoder {
    return &SchemaDecoder{json.NewDecoder(r)}
}

func (s *SchemaDecoder) ReadSchema() *SchemaRoot {
    var r SchemaRoot
    s.Decode(&r)
    r.FillInDatas()
    return &r
}
