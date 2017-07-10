<?xml version="1.0" encoding="ASCII"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">


  <xsl:template name="admon.graphic">
    <xsl:param name="node" select="."/>
    <xsl:value-of select="concat('../', $admon.graphics.path)"/>
    <xsl:choose>
      <xsl:when test="local-name($node)='note'">note</xsl:when>
      <xsl:when test="local-name($node)='warning'">warning</xsl:when>
      <xsl:when test="local-name($node)='caution'">caution</xsl:when>
      <xsl:when test="local-name($node)='tip'">tip</xsl:when>
      <xsl:when test="local-name($node)='important'">important</xsl:when>
      <xsl:otherwise>note</xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$admon.graphics.extension"/>
  </xsl:template>


  <xsl:template name="nongraphical.admonition">
    <xsl:param name="node" select="."/>
    <xsl:variable name="neo.admon.name">
      <xsl:choose>
        <xsl:when test="local-name($node)='note'">note</xsl:when>
        <xsl:when test="local-name($node)='warning'">warning</xsl:when>
        <xsl:when test="local-name($node)='caution'">caution</xsl:when>
        <xsl:when test="local-name($node)='tip'">tip</xsl:when>
        <xsl:when test="local-name($node)='important'">important</xsl:when>
        <xsl:otherwise>note</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <xsl:call-template name="common.html.attributes">
        <xsl:with-param name="inherit" select="1"/>
        <xsl:with-param name="class" select="concat('admonitionblock ', local-name(.))"/>
      </xsl:call-template>
      <xsl:call-template name="id.attribute"/>
      <xsl:if test="$admon.style != '' and $make.clean.html = 0">
        <xsl:attribute name="style">
          <xsl:value-of select="$admon.style"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:variable name="neo.admon.hastitle" select="$admon.textlabel != 0 or d:title or d:info/d:title"/>

      <table>
        <tbody>
          <xsl:choose>

            <xsl:when test="$neo.admon.hastitle">
              <tr>
                <td class="icon">
                  <xsl:attribute name="rowspan">
                    <xsl:value-of select='"2"'/>
                  </xsl:attribute>
                  <i>
                    <xsl:attribute name="class">
                      <xsl:value-of select="concat('fa icon-', $neo.admon.name)"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$neo.admon.name"/>
                    </xsl:attribute>
                  </i>
                </td>
                <th>
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </th>
              </tr>
              <tr>
                <td class="content">
                  <xsl:apply-templates/>
                </td>
              </tr>
            </xsl:when>

            <xsl:otherwise>
              <tr>
                <td class="icon">
                  <i>
                    <xsl:attribute name="class">
                      <xsl:value-of select="concat('fa icon-', $neo.admon.name)"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$neo.admon.name"/>
                    </xsl:attribute>
                  </i>
                </td>
                <td class="content">
                  <xsl:apply-templates/>
                </td>
              </tr>
            </xsl:otherwise>

          </xsl:choose>
        </tbody>
      </table>

    </div>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
