<?xml version="1.0" encoding="UTF-8"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

  <!-- a CSS link reference must take into account the relative
       path to a CSS file when chunked HTML is output to more than one directory -->
  <xsl:template name="make.css.link">
    <xsl:param name="css.filename" select="''"/>

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="substring($css.filename, 1, 2) = '//' or substring($css.filename, 1, 4) = 'http'">
          <xsl:value-of select="$css.filename"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="relative.path.link">
            <xsl:with-param name="target.pathname" select="$css.filename"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string-length($css.filename) != 0">
      <link rel="stylesheet" type="text/css" href="{$href}"/>
    </xsl:if>
  </xsl:template>

  <!-- And the same applies to script links -->
  <xsl:template name="make.script.link">
    <xsl:param name="script.filename" select="''"/>

    <!-- <xsl:message><xsl:text>        [-] </xsl:text><xsl:value-of select="$script.filename"/></xsl:message> -->

    <xsl:variable name="src">
      <xsl:choose>
        <xsl:when test="substring($script.filename, 1, 2) = '//' or substring($script.filename, 1, 4) = 'http'">
          <xsl:value-of select="$script.filename"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="relative.path.link">
            <xsl:with-param name="target.pathname" select="$script.filename"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string-length($script.filename) != 0">
      <script>
        <xsl:attribute name="src">
          <xsl:value-of select="$src"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="$html.script.type"/>
        </xsl:attribute>
        <xsl:call-template name="other.script.attributes">
          <xsl:with-param name="script.filename" select="$script.filename"/>
        </xsl:call-template>
      </script>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
