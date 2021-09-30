<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Schematron constraints for schema 'FKB-Høydekurve-5.0Utkast'</title>
  <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
  <ns prefix="fkbhk" uri="http://skjema.geonorge.no/SOSITEST/produktspesifikasjon/FKB-Høydekurve/5.0"/>
  <pattern>
    <rule context="fkbhk:Posisjonskvalitet">
      <assert test="fkbhk:datafangstmetodeHøyde/concat(@codeSpace,'/',text()) != 'dig'">Datafangstmetode Digitalisert skal ikke brukes på egenskapen datafangstmetodeHøyde</assert>
    </rule>
  </pattern>
</schema>
