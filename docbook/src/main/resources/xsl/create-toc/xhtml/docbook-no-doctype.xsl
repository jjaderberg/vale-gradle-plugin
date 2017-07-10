<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exsl d"
                version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook-no-doctype.xsl"/>

  <xsl:include href="param.xsl"/>
  <xsl:include href="verbatim.xsl"/>
  <xsl:include href="formal.xsl"/>
  <xsl:include href="table.xsl"/>
  <xsl:include href="sections.xsl"/>
  <xsl:include href="html.xsl"/>
  <xsl:include href="admon.xsl"/>
  <xsl:include href="glossary.xsl"/>
  <xsl:include href="block.xsl"/>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
