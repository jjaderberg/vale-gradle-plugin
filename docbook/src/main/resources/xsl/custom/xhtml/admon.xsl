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

      <table>
        <tbody>
          <tr>
            <td class="icon">
              <i>
                <xsl:attribute name="class">
                  <xsl:value-of select="concat('fa icon-', $neo.admon.name)"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="$neo.admon.name"/>
                </xsl:attribute>
                <!-- class="fa icon-{$neo.admon.name}" title="{$neo.admon.name}"></i> -->
              </i>
            </td>
            <td class="content">
              <xsl:apply-templates/>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- <xsl:if test="$admon.textlabel != 0 or title or info/title"> -->
      <!--   <h3 class="title"> -->
      <!--     <xsl:call-template name="anchor"/> -->
      <!--     <xsl:apply-templates select="." mode="object.title.markup"/> -->
      <!--   </h3> -->
      <!-- </xsl:if> -->
      <!-- <xsl:apply-templates/> -->

    </div>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
