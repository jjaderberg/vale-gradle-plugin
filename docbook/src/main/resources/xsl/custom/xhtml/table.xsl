<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:xtbl="xalan://com.nwalsh.xalan.Table"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:ptbl="http://nwalsh.com/xslt/ext/xsltproc/python/Table"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc stbl xtbl lxslt ptbl d"
                version="1.0">


  <xsl:template match="d:tgroup" name="tgroup">
    <xsl:if test="not(@cols) or @cols = '' or string(number(@cols)) = 'NaN'">
      <xsl:message terminate="yes">
        <xsl:text>Error: CALS tables must specify the number of columns.</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="summary">
      <xsl:call-template name="pi.dbhtml_table-summary"/>
    </xsl:variable>

    <xsl:variable name="cellspacing">
      <xsl:call-template name="pi.dbhtml_cellspacing"/>
    </xsl:variable>

    <xsl:variable name="cellpadding">
      <xsl:call-template name="pi.dbhtml_cellpadding"/>
    </xsl:variable>

    <!-- XXX: This is hard-coded because that is the smallest incremental change.
         This should be turned into a parameter somewhere, or get its value from
         template -->
    <xsl:variable name="placement" select="'before'"/>

    <div class="table">
      <!-- Get the ID, if any, of the <table> parent. -->
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>


      <table>
        <!-- common attributes should come from parent table, not tgroup -->
        <xsl:apply-templates select=".." mode="common.html.attributes"/>

        <xsl:choose>
          <!-- If there's a textobject/phrase for the table summary, use it -->
          <xsl:when test="../d:textobject/d:phrase">
            <xsl:attribute name="summary">
              <xsl:value-of select="../d:textobject/d:phrase"/>
            </xsl:attribute>
          </xsl:when>

          <!-- If there's a <?dbhtml table-summary="foo"?> PI, use it for
              the HTML table summary attribute -->
          <xsl:when test="$summary != ''">
            <xsl:attribute name="summary">
              <xsl:value-of select="$summary"/>
            </xsl:attribute>
          </xsl:when>

          <!-- Otherwise, if there's a title, use that -->
          <xsl:when test="../d:title">
            <xsl:attribute name="summary">
              <!-- This screws up on inline markup and footnotes, oh well... -->
              <xsl:value-of select="string(../d:title)"/>
            </xsl:attribute>
          </xsl:when>

          <!-- Otherwise, forget the whole idea -->
          <xsl:otherwise><!-- nevermind --></xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$cellspacing != '' or $html.cellspacing != ''">
          <xsl:attribute name="cellspacing">
            <xsl:choose>
              <xsl:when test="$cellspacing != ''">
                <xsl:value-of select="$cellspacing"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$html.cellspacing"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>

        <xsl:if test="$cellpadding != '' or $html.cellpadding != ''">
          <xsl:attribute name="cellpadding">
            <xsl:choose>
              <xsl:when test="$cellpadding != ''">
                <xsl:value-of select="$cellpadding"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$html.cellpadding"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>

        <xsl:if test="../@pgwide=1 or local-name(.) = 'entrytbl'">
          <xsl:attribute name="width">100%</xsl:attribute>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$table.borders.with.css != 0">
            <xsl:choose>
              <xsl:when test="../@frame='all' or (not(../@frame) and $default.table.frame='all')">
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'top'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'bottom'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'left'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'right'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="../@frame='topbot' or (not(../@frame) and $default.table.frame='topbot')">
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'top'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'bottom'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="../@frame='top' or (not(../@frame) and $default.table.frame='top')">
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'top'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="../@frame='bottom' or (not(../@frame) and $default.table.frame='bottom')">
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'bottom'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="../@frame='sides' or (not(../@frame) and $default.table.frame='sides')">
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'left'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                  <xsl:call-template name="border">
                    <xsl:with-param name="side" select="'right'"/>
                    <xsl:with-param name="style" select="$table.frame.border.style"/>
                    <xsl:with-param name="color" select="$table.frame.border.color"/>
                    <xsl:with-param name="thickness" select="$table.frame.border.thickness"/>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="../@frame='none'">
                <xsl:attribute name="style">
                  <xsl:text>border: none;</xsl:text>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">
                  <xsl:text>border-collapse: collapse;</xsl:text>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:when>
          <xsl:when test="../@frame='none' or (not(../@frame) and $default.table.frame='none') or local-name(.) = 'entrytbl'">
            <xsl:attribute name="border">0</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="border">1</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:variable name="colgroup">
          <colgroup>
            <xsl:call-template name="generate.colgroup">
              <xsl:with-param name="cols" select="@cols"/>
            </xsl:call-template>
          </colgroup>
        </xsl:variable>

        <xsl:variable name="explicit.table.width">
          <xsl:call-template name="pi.dbhtml_table-width">
            <xsl:with-param name="node" select=".."/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="table.width">
          <xsl:choose>
            <xsl:when test="$explicit.table.width != ''">
              <xsl:value-of select="$explicit.table.width"/>
            </xsl:when>
            <xsl:when test="$default.table.width = ''">
              <xsl:text>100%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$default.table.width"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="$default.table.width != ''                   or $explicit.table.width != ''">
          <xsl:attribute name="width">
            <xsl:choose>
              <xsl:when test="contains($table.width, '%')">
                <xsl:value-of select="$table.width"/>
              </xsl:when>
              <xsl:when test="$use.extensions != 0                           and $tablecolumns.extension != 0">
                <xsl:choose>
                  <xsl:when test="function-available('stbl:convertLength')">
                    <xsl:value-of select="stbl:convertLength($table.width)"/>
                  </xsl:when>
                  <xsl:when test="function-available('xtbl:convertLength')">
                    <xsl:value-of select="xtbl:convertLength($table.width)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:message terminate="yes">
                      <xsl:text>No convertLength function available.</xsl:text>
                    </xsl:message>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$table.width"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>


        <!-- If the current table has a title (is a formal table) then generate
            a <caption>. -->
        <xsl:if test="../d:title">
          <xsl:choose>
            <xsl:when test="$placement = 'before'">
              <xsl:call-template name="neo.formal.object.heading">
                <xsl:with-param name="object" select=".."/>
              </xsl:call-template>
              <xsl:if test="local-name(.) = 'table'">
                <xsl:call-template name="table.longdesc"/>
              </xsl:if>
              <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
                <xsl:apply-templates/>
              <xsl:if test="local-name(.) = 'table'">
                <xsl:call-template name="table.longdesc"/>
              </xsl:if>
              <xsl:call-template name="neo.formal.object.heading">
                <xsl:with-param name="object" select=".."/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$use.extensions != 0                       and $tablecolumns.extension != 0">
            <xsl:choose>
              <xsl:when test="function-available('stbl:adjustColumnWidths')">
                <xsl:copy-of select="stbl:adjustColumnWidths($colgroup)"/>
              </xsl:when>
              <xsl:when test="function-available('xtbl:adjustColumnWidths')">
                <xsl:copy-of select="xtbl:adjustColumnWidths($colgroup)"/>
              </xsl:when>
              <xsl:when test="function-available('ptbl:adjustColumnWidths')">
                <xsl:copy-of select="ptbl:adjustColumnWidths($colgroup)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="yes">
                  <xsl:text>No adjustColumnWidths function available.</xsl:text>
                </xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$colgroup"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="d:thead"/>
        <xsl:apply-templates select="d:tfoot"/>
        <xsl:apply-templates select="d:tbody"/>

        <xsl:if test=".//d:footnote|../d:title//d:footnote">
          <tbody class="footnotes">
            <tr>
              <td colspan="{@cols}">
                <xsl:apply-templates select=".//d:footnote|../d:title//d:footnote" mode="table.footnote.mode"/>
              </td>
            </tr>
          </tbody>
        </xsl:if>
      </table>
    </div>
  </xsl:template>

<!-- ====================================================================== -->


</xsl:stylesheet>

<!-- vim: set ts=2 sw=2: -->
