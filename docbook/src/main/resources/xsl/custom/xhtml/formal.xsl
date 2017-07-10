<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

  <xsl:template name="calsTable">
    <xsl:if test="d:tgroup/d:tbody/d:tr |d:tgroup/d:thead/d:tr |d:tgroup/d:tfoot/d:tr">
      <xsl:message terminate="yes">Broken table: tr descendent of CALS Table.</xsl:message>
    </xsl:if>

    <xsl:variable name="param.placement"
        select="substring-after(normalize-space($formal.title.placement), concat(local-name(.), ' '))"/>

    <xsl:variable name="placement">
      <xsl:choose>
        <xsl:when test="contains($param.placement, ' ')">
          <xsl:value-of select="substring-before($param.placement, ' ')"/>
        </xsl:when>
        <xsl:when test="$param.placement = ''">before</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$param.placement"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="neo.formal.object">
      <xsl:with-param name="placement" select="$placement"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="d:table|d:informaltable" mode="class.value">
    <xsl:choose>
      <xsl:when test="@tabstyle">
        <xsl:value-of select="@tabstyle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local-name(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Use for tables. Probably not useful for other formal
       objects so might should rename it, but the current name indicates
       which template it replaces, which is also useful. -->
  <xsl:template name="neo.formal.object">
    <xsl:param name="placement" select="'before'"/>
    <xsl:param name="class">
      <xsl:apply-templates select="." mode="class.value"/>
    </xsl:param>

    <xsl:call-template name="id.warning"/>

    <xsl:variable name="content">

      <xsl:apply-templates/>

      <xsl:if test="not($formal.object.break.after = '0')">
        <br class="{$class}-break"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="floatstyle">
      <xsl:call-template name="floatstyle"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$floatstyle != ''">
        <xsl:call-template name="floater">
          <xsl:with-param name="class"><xsl:value-of select="$class"/>-float</xsl:with-param>
          <xsl:with-param name="floatstyle" select="$floatstyle"/>
          <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- ====================================================================== -->

  <!-- Use to get title of a table. Probably not useful for other formal
       objects so might should rename it, but the current name indicates
       which template it replaces, which is also useful. -->
  <xsl:template name="neo.formal.object.heading">
    <xsl:param name="object" select="."/>
    <xsl:param name="title">
      <xsl:apply-templates select="$object" mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </xsl:param>
        <xsl:variable name="html.class" select="concat(local-name($object),'-title')"/>
        <caption class="{$html.class}">
            <xsl:copy-of select="$title"/>
        </caption>
  </xsl:template>

<!-- ====================================================================== -->

  <!-- CUSTOMIZATION 2016-07-21
       The roles of example and informalexample blocks don't get set as CSS classes in the XHTML5 chunker.
       Let's fix it.
    -->
  <xsl:template match="d:example|d:informalexample" mode="class.value">
    <xsl:param name="class" select="local-name(.)"/>
    <!-- permit customization of class value only -->
    <!-- Use element name by default -->
    <!-- <xsl:message> -->
    <!--   <xsl:text>    [*] EXAMPLE mode="class.value"</xsl:text> -->
    <!--   <xsl:text>&#xa;        @role: </xsl:text><xsl:value-of select="@role"/> -->
    <!--   <xsl:text>&#xa;        $class: </xsl:text><xsl:value-of select="$class"/> -->
    <!-- </xsl:message> -->
    <xsl:choose>
      <xsl:when test="@role">
        <xsl:value-of select="concat($class, ' ', @role)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$class"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- END CUSTOMIZATION -->

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
