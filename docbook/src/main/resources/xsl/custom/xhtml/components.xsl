<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

  <!-- 2017-11-13 Override for section to include role of there is one -->
  <xsl:template match="d:chapter" mode="class.value">
    <xsl:param name="class" select="local-name(.)"/>
    <xsl:variable name="classvalue">
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:value-of select="concat(local-name(.), ' ', @role)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$classvalue"/>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
