<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
                xmlns:xverb="xalan://com.nwalsh.xalan.Verbatim"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:d="http://docbook.org/ns/docbook"
                exclude-result-prefixes="sverb xverb lxslt exsl d"
                version="1.0">

<xsl:template match="d:programlisting|d:screen|d:synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>

  <xsl:call-template name="anchor"/>

  <xsl:variable name="div.element">pre</xsl:variable>

    <xsl:element name="{$div.element}">
      <xsl:apply-templates select="." mode="common.html.attributes">
        <xsl:with-param name="class" select="concat(local-name(.), ' highlight')"/>
      </xsl:apply-templates>

      <xsl:call-template name="id.attribute" />
      <code>
        <xsl:if test="@language != ''">
          <xsl:attribute name="data-lang">
              <xsl:value-of select="@language" />
          </xsl:attribute>
        </xsl:if>
      <xsl:apply-templates />
      </code>
    </xsl:element>

</xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
