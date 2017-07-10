<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">


  <xsl:template match="d:abstract" priority="1">
    <div>
      <xsl:call-template name="common.html.attributes"/>
      <xsl:call-template name="anchor"/>

      <xsl:if test="$abstract.notitle.enabled = 0">
        <xsl:call-template name="formal.object.heading">
          <xsl:with-param name="title">
            <xsl:apply-templates select="." mode="title.markup"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <!-- <xsl:call-template name="formal.object.heading"> -->
      <!--   <xsl:with-param name="title"> -->
      <!--     <xsl:apply-templates select="." mode="title.markup"> -->
      <!--       <xsl:with-param name="allow-anchors" select="'1'"/> -->
      <!--     </xsl:apply-templates> -->
      <!--   </xsl:with-param> -->
      <!-- </xsl:call-template> -->

      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
