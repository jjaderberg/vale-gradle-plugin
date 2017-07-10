<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook">

  <xsl:include href="asciidoc-book-id-append.xsl" />

  <!-- 2016-08-03
       Substitute bad IDs that we can't easily change in the source.
       Log that we are doing this as a reminder to eventually fix it in the source. -->
  <xsl:template match="@linkend[parent::db:xref]">
    <xsl:variable name="linkend" select="."/>
    <!-- <xsl:message><xsl:value-of select="$linkend"/></xsl:message> -->
    <xsl:choose>
      <xsl:when test="$linkend = 'rest-api-transactional'">
        <xsl:message>
          <xsl:text>  [-] substituting http-api-transactional for </xsl:text><xsl:value-of select="$linkend"/>
        </xsl:message>
        <xsl:apply-templates/>
        <xsl:attribute name="linkend">http-api-transactional</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:message><xsl:text>  [-] no substitution for </xsl:text><xsl:value-of select="$linkend"/></xsl:message> -->
        <xsl:copy-of select="$linkend"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 2016-08-03
       Drop some paragraphs that contain bad xrefs and that we can't easily remove
       from the source. Log that we do it as a reminder to eventually fix it in the source.
       -->
  <xsl:template match="db:simpara[descendant::db:xref]">
    <xsl:variable name="linkend" select="descendant::db:xref/@linkend"/>
      <!-- <xsl:message><xsl:text>    [+] </xsl:text><xsl:value-of select="$linkend"/></xsl:message> -->
      <xsl:choose>
        <xsl:when test="$linkend = 'data-modeling-examples'">
          <xsl:message><xsl:text>  [-] dropping paragraph containing </xsl:text><xsl:value-of select="$linkend"/></xsl:message>
        </xsl:when>
        <xsl:when test="$linkend = 'tutorials-cypher-java'">
          <xsl:message><xsl:text>  [-] dropping paragraph containing </xsl:text><xsl:value-of select="$linkend"/></xsl:message>
        </xsl:when>
        <xsl:when test="$linkend = 'tutorials-cypher-parameters-java'">
          <xsl:message><xsl:text>  [-] dropping paragraph containing </xsl:text><xsl:value-of select="$linkend"/></xsl:message>
        </xsl:when>
        <xsl:when test="$linkend = 'rest-api-schema-constraints'">
          <xsl:message><xsl:text>  [-] dropping paragraph containing </xsl:text><xsl:value-of select="$linkend"/></xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
