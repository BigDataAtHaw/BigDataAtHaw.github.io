# Schreiben eines einfachen XML Parsers:

* Bekomme ein Object aus einer XML Datei:
 
 * DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
 * DocumentBuilder builder = factory.newDocumentBuilder();
 * Document document = builder.parse(new File(path));

 * Element element = document.getDocumentElement();

 * NamedNodeMap attribute = element.getAttributes(); 
 * Node attribut = attribute.item(i);
 * attribute.getNodeValue();

 * NodeList nodeList = element.getChildNodes();
 * Node node = nodeList.item(k);
 * node.hasAttributes()

 * NamedNodeMap attributeMap = node.getAttributes();
 * Node attribut = attributeMap.item(i);
 * attribut.getNodeName()
 * attribut.getNodeValue()



* Schreibe aus einem Object eine XML Datei:

 * DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
 * DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
 * Document doc = docBuilder.newDocument();

 * Element rootElement = doc.createElement(sensorString);

 * doc.appendChild(rootElement);

 * Attr idAttr = doc.createAttribute(id);
 * idAttr.setValue(sensor.getiD());
 * rootElement.setAttributeNode(idAttr);

 * Element messungElement = doc.createElement(messung);

 * rootElement.appendChild(messungElement);

 * Attr wertAttr = doc.createAttribute(wert);
 * wertAttr.setValue(String.valueOf(m.getWert()));
 * messungElement.setAttributeNode(wertAttr);
 * Attr zeitAttr = doc.createAttribute(zeitStempel);
 * zeitAttr.setValue(String.valueOf(m.getZeitstempel()));
 * messungElement.setAttributeNode(zeitAttr);
		

 * TransformerFactory transformerFactory = TransformerFactory.newInstance();
 * Transformer transformer = transformerFactory.newTransformer();

 * DOMSource source = new DOMSource(doc);
 * StreamResult result = new StreamResult(new File(fileName));
 * transformer.transform(source, result);


* doc.createElement(name);
* doc.appendChild(element);

## dtd:

<!ELEMENT Sensor (Messung)*>
<!ATTLIST Sensor id CDATA #REQUIRED>
<!ELEMENT Messung (Empty)>
<!ATTLIST Messung wert CDATA #REQUIRED
			zeitstempel CDATA #REQUIRED>







