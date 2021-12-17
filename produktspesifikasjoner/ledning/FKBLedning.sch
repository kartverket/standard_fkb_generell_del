<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <title>Schematron constraints for schema 'FKB-Ledning-5.0'</title>
  <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
  <ns prefix="app" uri="http://skjema.geonorge.no/SOSI/produktspesifikasjon/FKB-Ledning/5.0"/>
  <ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <pattern>
    <rule context="app:Mast">
      <assert test="not(app:driftsmerking) or not(app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href]) or not((app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href])[app:driftsmerking != current()/app:driftsmerking])">driftsmerking på Mast og Masteomriss skal være like: hvis Mast har driftsmerking og har tilhørende Masteomriss, skal driftsmerking på Mast og Masteomriss være like</assert>
    </rule>
    <rule context="app:Nettverkstasjon">
      <assert test="not(app:driftsmerking) or not(app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href]) or app:driftsmerking = (app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href])/app:driftsmerking">driftsmerking på Nettverkstasjon og Nettverkstasjonomriss skal være like: hvis Nettverkstasjon har driftsmerking og har tilhørende Nettverkstasjonomriss, skal driftsmerking på Nettverkstasjon og Nettverkstasjonomriss være like</assert>
    </rule>
    <rule context="app:Posisjonskvalitet">
      <assert test="app:datafangstmetodeHøyde/concat(@codeSpace,'/',text()) != 'dig'">ugyldige datafangstmetoder for høyde: Datafangstmetode Digitalisert skal ikke brukes på egenskapen datafangstmetodeHøyde</assert>
    </rule>
    <rule context="app:Vindturbin">
      <assert test="not(app:driftsmerking) or not(app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href]) or app:driftsmerking = (app:omriss/* | //*[concat('#',@gml:id)=current()/app:omriss/@xlink:href])/app:driftsmerking">driftsmerking på Vindturbin og Vindturbinomriss skal være like: hvis Vindturbin har driftsmerking og har tilhørende Vindturbinomriss, skal driftsmerking på Vindturbin og Vindturbinomriss være like</assert>
    </rule>
  </pattern>
</schema>
