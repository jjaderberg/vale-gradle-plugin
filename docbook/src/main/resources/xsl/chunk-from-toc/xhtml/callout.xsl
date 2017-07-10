<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
                xmlns:xverb="xalan://com.nwalsh.xalan.Verbatim"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="sverb xverb lxslt d"
                version="1.0">


<!-- CUSTOMIZATION:
      1) CodeMirror eats the markup that's put into a listing block, breaking
         links between 'co' and 'calloutlist'. Therefore, remove these links.
      2) Use FontAwesome icons instead of the DocBook callout graphics.

      The result is the same as from the Asciidoctor HTML5 backend, except we use
      <span> instead of <i> for FontAwesome icons.
      -->

<!-- ======================================================================== -->

  <xsl:template match="d:co" name="co">
    <xsl:variable name="context.colist" select="boolean(@linkends)"/>
    <xsl:apply-templates select="." mode="callout-bug">
      <xsl:with-param name="context.colist" select="false()"/>
    </xsl:apply-templates>
  </xsl:template>

<!-- ======================================================================== -->

  <xsl:template match="d:co" mode="callout-bug">
    <xsl:param name="context.colist" select="true()" />
    <xsl:call-template name="callout-bug">
      <xsl:with-param name="conum">
        <xsl:number count="d:co" level="any" from="d:programlisting|d:screen|d:literallayout|d:synopsis" format="1"/>
      </xsl:with-param>
      <xsl:with-param name="context.colist" select="$context.colist" />
    </xsl:call-template>
  </xsl:template>

<!-- ======================================================================== -->

  <xsl:template name="callout-bug">
    <xsl:param name="conum" select="1"/>
    <xsl:param name="context.colist" select="true()" />
    <xsl:if test="$callout.graphics != 0 and $conum &lt;= $callout.graphics.number.limit">
      <xsl:choose>
        <xsl:when test="$context.colist">
          <span class="conum" data-value="{$conum}">
          </span>
          <b>
            <xsl:value-of select="$conum"/>
          </b>
        </xsl:when>
        <xsl:otherwise>
          <i class="conum" data-value="{$conum}">
          </i>
          <b>
            <xsl:text>(</xsl:text>
            <xsl:value-of select="$conum"/>
            <xsl:text>)</xsl:text>
          </b>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

<!-- ======================================================================== -->

  <!-- FROM http://docbook.sourceforge.net/release/xsl/docbook-xsl-1.79.1/xhtml/lists.xsl -->
  <xsl:template name="callout.arearef">
    <xsl:param name="arearef"/>
    <xsl:variable name="targets" select="key('id',$arearef)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:call-template name="check.id.unique">
      <xsl:with-param name="linkend" select="$arearef"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="count($target)=0">
        <xsl:text>???</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($target)='co'">
        <!-- <a> -->
        <!--   <xsl:attribute name="href"> -->
        <!--     <xsl:text>#</xsl:text> -->
        <!--     <xsl:value-of select="$arearef"/> -->
        <!--   </xsl:attribute> -->
          <xsl:apply-templates select="$target" mode="callout-bug"/>
        <!-- </a> -->
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="local-name($target)='areaset'">
        <xsl:call-template name="callout-bug">
          <xsl:with-param name="conum">
            <xsl:apply-templates select="$target" mode="conumber"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name($target)='area'">
        <xsl:choose>
          <xsl:when test="$target/parent::areaset">
            <xsl:call-template name="callout-bug">
              <xsl:with-param name="conum">
                <xsl:apply-templates select="$target/parent::areaset" mode="conumber"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="callout-bug">
              <xsl:with-param name="conum">
                <xsl:apply-templates select="$target" mode="conumber"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
