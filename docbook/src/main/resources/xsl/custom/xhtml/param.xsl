<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

  <xsl:param name="toc.section.depth">1</xsl:param>

  <xsl:param name="generate.section.toc.level">1</xsl:param>

  <xsl:param name="toc.max.depth">8</xsl:param>

  <xsl:param name="section.autolabel">1</xsl:param>

  <xsl:param name="section.autolabel.max.depth">3</xsl:param>

  <!-- <xsl:param name="section.autolabel.max.depth">8</xsl:param> -->

<xsl:param name="generate.toc">
appendix          toc,title
article/appendix  nop
article           toc,title
book              toc,title
chapter           toc,title
part              toc,title
preface           nop
qandadiv          toc
qandaset          toc
reference         toc,title
sect1             toc
sect2             toc
sect3             toc
sect4             toc
sect5             toc
section           toc,title
set               toc,title
glossary          toc,title
</xsl:param>


  <xsl:param name="section.label.includes.component.label">1</xsl:param>

  <xsl:param name="generate.legalnotice.link">1</xsl:param>

  <xsl:param name="suppress.footer.navigation">1</xsl:param>

  <xsl:param name="chunker.output.encoding">UTF-8</xsl:param>

  <xsl:param name="chunk.fast">1</xsl:param>

  <xsl:param name="abstract.notitle.enabled">1</xsl:param>

  <xsl:param name="table.borders.with.css" select="0"></xsl:param>

  <xsl:param name="neo.search">0</xsl:param>

  <xsl:param name="formal.object.break.after">0</xsl:param>

  <xsl:param name="neo.embedded.javascript">0</xsl:param>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
