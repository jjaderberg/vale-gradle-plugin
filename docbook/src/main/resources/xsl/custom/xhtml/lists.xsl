<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!-- ==================================================================== -->

  <!-- CUSTOMIZATION 2016-09-12
       The roles of variablelists don't get set as CSS classes in the XHTML5 chunker.
       Let's fix it.
    -->
  <xsl:template match="d:variablelist" mode="class.value">
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
<!-- vim: set sw=2 ts=2: -->
