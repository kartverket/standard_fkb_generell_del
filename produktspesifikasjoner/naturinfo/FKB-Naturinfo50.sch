<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Schematron constraints for schema 'FKB-Naturinfo-5.0Utkast'</title>
  <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
  <ns prefix="app" uri="https://skjema.geonorge.no/SOSITEST/produktspesfikasjon/FKB-Naturinfo/5.0"/>
  <pattern>
    <rule context="app:Posisjonskvalitet">
      <assert test="app:datafangstmetodeHøyde/concat(@codeSpace,'/',text()) != 'dig'">Datafangstmetode Digitalisert skal ikke brukes på egenskapen datafangstmetodeHøyde</assert>
    </rule>
  </pattern>
</schema>