Option Explicit

!INC Local Scripts.EAConstants-VBScript

' Script Name: AsciidocRegistreringsinstruksSamletabell
' Original Author: Geir Myhr Øien
' Purpose: Lister ut objekttyper for hver fotogrammetriske registreringsinstruks som ledd i en samletabell.
' Basic: Scriptet bygger på versjon 2022-12-17 for AsciidocRegistreringinstruks.adoc
' Date: 11.01.2022
' Version: 0.1ish
'
' Version 0.1: 2021-01-11 Geir Myhr Øien: Første versjon av scriptet
'
' Kjøres i EA fra pakka "Fotogrammetrisk registreringsinstruks"
' Pakka må ha følgende tagger: FKB-datasett (med verdi f.eks. FKB-Arealbruk), FKB-versjon (med verdi f.eks. 5.0) og FKB-underversjon (med verdi f.eks. 2022-01-01)
'
Dim imgfolder, imgparent, parentimg, files
Dim diagCounter
Dim imgFSO
Dim datasett, underversjon, versjon, datasettUrl
'
' Project Browser Script main function
Sub OnProjectBrowserScript()

    Dim treeSelectedType
    treeSelectedType = Repository.GetTreeSelectedItemType()

    Select Case treeSelectedType

        Case otPackage
			Repository.EnsureOutputVisible "Script"
			Repository.ClearOutput "Script"
            ' Code for when a package is selected
			diagCounter = 0
			Dim thePackage As EA.Package
			set thePackage = Repository.GetTreeSelectedObject()
			imgfolder = "app_img"
			Set imgFSO=CreateObject("Scripting.FileSystemObject")
			imgparent = imgFSO.GetParentFolderName(Repository.ConnectionString())  & "\" & imgfolder
			if false then				
				Session.Output(" DEBUG.")
				Session.Output(" imgfolder: " & imgfolder  & "...")
				Session.Output(" imgFSO.GetAbsolutePathName: " & imgFSO.GetAbsolutePathName("./")  & "...")
				Session.Output(" Repository.ConnectionString: " & Repository.ConnectionString() & "...")
				Session.Output(" imgFSO.GetBaseName: " & imgFSO.GetBaseName(Repository.ConnectionString())  & "...")
				Session.Output(" imgFSO.GetParentFolderName: " & imgFSO.GetParentFolderName(Repository.ConnectionString())  & "...")
				Session.Output(" imgparent: " & imgparent  & "...")
			end if
			if not imgFSO.FolderExists(imgparent) then
				imgFSO.CreateFolder imgparent
			end if
			
			Session.Output("// Start of Registreringsinstruks UML-model")
			Call ListAsciiDoc(thePackage)
			Session.Output("// End of Registreringsinstruks UML-model")
			Set imgFSO = Nothing
        Case Else
            ' Error message
            Session.Prompt "This script does not support items of this type.", promptOK

    End Select

End Sub


Sub ListAsciiDoc(thePackage)

	Dim element As EA.Element
	dim tag as EA.TaggedValue
	Dim diag As EA.Diagram
	Dim projectclass As EA.Project
	set projectclass = Repository.GetProjectInterface()
	
'-----------------PAKKE-----------------

	'' Sjekker opp pakken inneholder "fotogrammetrisk" i pakkenavnet
	if InStr(LCase(thePackage.Name),"fotogrammetrisk") > 0 then
		for each tag in thePackage.element.TaggedValues
			'Session.Output("|Tag: "&tag.Name&"")
			if tag.Value <> "" then	
				if LCase(tag.Name) = "fkb-datasett" then
					datasett = tag.Value
				elseif LCase(tag.Name) = "fkb-underversjon" then
					underversjon = tag.Value
				elseif LCase(tag.Name) = "fkb-versjon" then
					versjon = tag.Value
				end if
			end if
		next
		datasettUrl = "{reginstrbase-url}/"&datasett&"/"&versjon&"/{reginstr-type}_"&underversjon
		'Session.Output(datasettUrl)
	end if

'-----------------FEATURETYPE-----------------

	For each element in thePackage.Elements
		If element.Type = "Class" and (Ucase(element.Stereotype) = "FEATURETYPE" or Ucase(element.Stereotype) = "") Then
	'	If Ucase(element.Stereotype) = "FEATURETYPE" or Ucase(element.Stereotype) = "" Then
			Call ObjektOgDatatyper(element)
		End if
	Next
		
	dim pack as EA.Package
	for each pack in thePackage.Packages
		Call ListAsciiDoc(pack)
	next

end sub

'-----------------ObjektOgDatatyper-----------------
Sub ObjektOgDatatyper(element)
	Dim att As EA.Attribute
	dim tag as EA.TaggedValue
	Dim con As EA.Connector
	Dim fil As EA.File
	Dim supplier As EA.Element
	Dim client As EA.Element
	Dim association
	Dim aggregation
	association = False
	Dim generalizations
	Dim numberSpecializations ' tar også med antall realiseringer her
	Dim textVar, addnotes, punktum
	dim externalPackage
	Dim fkbminA, fkbminB, fkbminC, fkbminD, fkbA, fkbB, fkbC, fkbD

	Session.Output(" ")
	
	'' Skriver ut datasettnavn og versjon 
	Session.Output("|"&Mid(datasett,5,Len(datasett)-4)&" "&versjon)
	'' Skriver ut objekttypenavn
	Session.Output("|"&datasettUrl&"/#"&LCase(element.Name)&"["&element.Name&"]")
	'' Skriver ut geometri
	call listGeometri(element)
	'' Skriver ut fkb-område og minstemål
	for each tag in element.TaggedValues								
		if tag.Value <> "" then	
			if Mid(tag.Name,1,3) = "FKB" then
				'call listFkbTagTabell(tag.Name, tag.Value)
				if LCase(tag.Name) = "fkb_minstestørrelse_a" then
					fkbminA = tag.Value
				elseif LCase(tag.Name) = "fkb_minstestørrelse_b" then
					fkbminB = tag.Value
				elseif LCase(tag.Name) = "fkb_minstestørrelse_c" then
					fkbminC	= tag.Value
				elseif LCase(tag.Name) = "fkb_minstestørrelse_d" then
					fkbminD	= tag.Value
				elseif LCase(tag.Name) = "fkb-a" then
					fkbA = tag.Value
				elseif LCase(tag.Name) = "fkb-b" then
					fkbB = tag.Value
				elseif LCase(tag.Name) = "fkb-c" then
					fkbC = tag.Value
				elseif LCase(tag.Name) = "fkb-d" then
					fkbD = tag.Value
				end if
			end if
		end if
	next
	Session.Output("|"&fkbA)
	Session.Output("|"&fkbB)
	Session.Output("|"&fkbC)
	Session.Output("|"&fkbD)
	Session.Output("| ")
	if fkbminA <> "" then
		Session.Output("FKB-A: "&fkbminA&+" +")
	end if
	if fkbminB <> "" then
		Session.Output("FKB-B: "&fkbminB&+" +")
	end if
	if fkbminC <> "" then
		Session.Output("FKB-C: "&fkbminC&+" +")
	end if
	if fkbminD <> "" then
		Session.Output("FKB-D: "&fkbminD&+" +")
	end if
	
End sub
'-----------------ObjektOgDatatyper End-----------------


'--------------------Start Sub-------------
sub listGeometri(element)
Dim pktum, eskap, stereo, geometri, teller
Dim datatype As EA.Element
Dim super As EA.Element
Dim att As EA.Attribute
dim tag as EA.TaggedValue
dim conn as EA.Collection

	for each conn in element.Connectors
		if conn.Type = "Generalization" then
			if element.ElementID = conn.ClientID then
				set super = Repository.GetElementByID(conn.SupplierID)
				call listGeometri(super)
			end if
		end if
	next

	geometri = ""

	for each att in element.Attributes
		if att.Type = "Punkt" or att.Type = "Sverm" or att.Type = "Kurve" or att.Type = "Flate" or Mid(att.Type,1,3) = "GM_" then
			if att.Type = "GM_Point" then
				geometri = geometri&"Punkt, "
			elseif att.Type = "GM_Curve" then
				geometri = geometri&"Kurve, "
			elseif att.Type = "GM_Surface" then
				geometri = geometri&"Flate, "
			else
				geometri = geometri&att.Type&", "
			end if
		end if
	next
	
	if geometri <> "" then
		Session.Output("|"&Mid(geometri,1,Len(geometri)-2))
	end if
	
end sub
' ----------------- end sub


'-----------------Funksjon for full path-----------------
function getPath(package)
	dim path
	dim parent
	if package.parentID <> 0 then
		if package.Element.Stereotype = "" then
			path = package.Name
		else
			path = "«" + package.Element.Stereotype + "» " + package.Name
		end if

		if ucase(package.Element.Stereotype) <> "APPLICATIONSCHEMA" then
			set parent = Repository.GetPackageByID(package.ParentID)
			path = getPath(parent) + "/" + path
		end if
	end if
	getPath = path
end function
'-----------------Funksjon for full path End-----------------



'-----------------Funksjon for å sjekke om egenskap finnes i denne klassen Start-----------------
function getAttribute(element,attributeName)
	Dim att As EA.Attribute
	getAttribute = false
	if element.Attributes.Count > 0 then
		for each att in element.Attributes
			if att.Name = attributeName then
				getAttribute = true
			end if
		next
	end if
end function
'-----------------Funksjon End-----------------



'-----------------Funksjon for å hente notefelt fra navngitt egenskap i en klasaseStart-----------------
function getAttributeNotes(element,attributeName)
	Dim att As EA.Attribute
	getAttributeNotes = ""
	if element.Attributes.Count > 0 then
		for each att in element.Attributes
			if att.Name = attributeName then
				getAttributeNotes = att.Notes
			end if
		next
	end if
end function
'-----------------Funksjon for å hente notefelt fra egenskap End-----------------



'-----------------Function underscore2space Start-----------------
function underscore2space(txt)
	'replaces underscores with spaces
    Dim res, tegn, i
	underscore2space = ""

	res = ""
	' loop gjennom alle tegn
	For i = 1 To Len(txt)
		tegn = Mid(txt,i,1)
		If tegn = "_" Then
			res = res + " "
		Else
			res = res + Mid(txt,i,1)
		end if
		  
	Next
		
	underscore2space = res

end function
'-----------------Function underscore2space End-----------------


'-----------------Function getCleanDefinition Start-----------------
function getCleanDefinition(txt)
	'removes all formatting in notes fields, except crlf
    Dim res, tegn, i, u
    u=0
	getCleanDefinition = ""

		res = ""
		txt = Trim(txt)
		For i = 1 To Len(txt)
		  tegn = Mid(txt,i,1)
			if tegn = "," then tegn = " " 'for adoc
			If tegn = "<" Then
				u = 1
				tegn = " "
			end if 
			If tegn = ">" Then
				u = 0
				tegn = " "
			end if
			If tegn < " " Then
				res = res + " "
			Else
				if u = 0 then
					res = res + Mid(txt,i,1)
				end if
			End If
		  
		Next
		
	getCleanDefinition = res

end function
'-----------------Function getCleanDefinition End-----------------



function getTaggedValue(element,taggedValueName)
		dim i, existingTaggedValue
		getTaggedValue = ""
		for i = 0 to element.TaggedValues.Count - 1
			set existingTaggedValue = element.TaggedValues.GetAt(i)
			if existingTaggedValue.Name = taggedValueName then
				getTaggedValue = existingTaggedValue.Value
			end if
		next
end function

function getPackageTaggedValue(package,taggedValueName)
		dim i, existingTaggedValue
		getPackageTaggedValue = ""
		for i = 0 to package.element.TaggedValues.Count - 1
			set existingTaggedValue = package.element.TaggedValues.GetAt(i)
			if existingTaggedValue.Name = taggedValueName then
				getPackageTaggedValue = existingTaggedValue.Value
			end if
		next
end function

function getConnectorEndTaggedValue(connectorEnd,taggedValueName)
	getConnectorEndTaggedValue = ""
	if not connectorEnd is nothing and Len(taggedValueName) > 0 then
		dim existingTaggedValue as EA.RoleTag 
		dim i
		for i = 0 to connectorEnd.TaggedValues.Count - 1
			set existingTaggedValue = connectorEnd.TaggedValues.GetAt(i)
			if existingTaggedValue.Tag = taggedValueName then
				getConnectorEndTaggedValue = existingTaggedValue.Value
			end if 
		next
	end if 
end function 


OnProjectBrowserScript