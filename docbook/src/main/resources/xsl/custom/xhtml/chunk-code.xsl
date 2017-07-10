<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0"
                exclude-result-prefixes="exsl cf d"
                version="1.0">

<!-- ==================================================================== -->

  <xsl:param name="use.id.as.dirname" select="0"/>

<!-- ==================================================================== -->

<xsl:template match="*" mode="recursive-chunk-filename" priority="1">
  <xsl:param name="recursive" select="false()"/>

  <!-- returns the filename of a chunk -->
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:variable name="dbhtml-filename">
    <xsl:call-template name="pi.dbhtml_filename"/>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$dbhtml-filename != ''">
        <xsl:value-of select="$dbhtml-filename"/>
      </xsl:when>
      <!-- if this is the root element, use the root.filename -->
      <xsl:when test="not(parent::*) and $root.filename != ''">
        <xsl:value-of select="$root.filename"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <!-- Special case -->
      <xsl:when test="self::d:legalnotice and not($generate.legalnotice.link = 0)">
        <xsl:choose>
          <xsl:when test="(@id or @xml:id) and not($use.id.as.filename = 0)">
            <!-- * if this legalnotice has an ID, then go ahead and use -->
            <!-- * just the value of that ID as the basename for the file -->
            <!-- * (that is, without prepending an "ln-" too it) -->
            <xsl:value-of select="(@id|@xml:id)[1]"/>
            <xsl:value-of select="$html.ext"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- * otherwise, if this legalnotice does not have an ID, -->
            <!-- * then we generate an ID... -->
            <xsl:variable name="id">
              <xsl:call-template name="object.id"/>
            </xsl:variable>
            <!-- * ...and then we take that generated ID, prepend an -->
            <!-- * "ln-" to it, and use that as the basename for the file -->
            <xsl:value-of select="concat('ln-',$id,$html.ext)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- if there's no dbhtml filename, and if we're to use IDs as -->
      <!-- filenames, then use the ID to generate the filename. -->
      <!-- BEGIN CUSTOMIZATION
           added parameter $use.id.as.dirname
           When set, use the ID of the top element in the chunk as the directory name
           and save the chunk as index.html in that directory.
           Example:
           book/index.html
           book/chapter1/index.html
           book/chapter2/index.html

           When the chunking is 'nested' an additional level deep, also use the
           ID of parent in the path name.
           Example:
           book/index.html
           book/chapter1/index.html
           book/chapter1/once-upon-a-time/index.html
           book/chapter2/index.hml
           book/chapter2/the-story-of-a-century/index.html
           -->
      <xsl:when test="(@id or @xml:id)">
        <xsl:choose>
          <xsl:when test="$use.id.as.filename != 0">
            <xsl:value-of select="(@id|@xml:id)[1]"/>
            <xsl:value-of select="$html.ext"/>
          </xsl:when>
          <xsl:when test="$use.id.as.dirname != 0">
            <xsl:for-each select="ancestor::*[ancestor::*]">
              <xsl:variable name="up.id" select="(@id|@xml:id)[1]"/>
              <xsl:if test="$up.id">
                <xsl:value-of select="concat($up.id, '/')"/>
              </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="(@id|@xml:id)[1]"/>
            <xsl:text>/index</xsl:text>
            <xsl:value-of select="$html.ext"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!-- END CUSTOMIZATION -->
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk='0'">
      <!-- if called on something that isn't a chunk, walk up... -->
      <xsl:choose>
        <xsl:when test="count(parent::*)>0">
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="$recursive"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- unless there is no up, in which case return "" -->
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not($recursive) and $filename != ''">
      <!-- if this chunk has an explicit name, use it -->
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <!-- treat nested set separate from root -->
    <xsl:when test="self::d:set and ancestor::d:set">
      <xsl:text>se</xsl:text>
      <xsl:number level="any" format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:set">
      <xsl:value-of select="$root.filename"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:book">
      <xsl:text>bk</xsl:text>
      <xsl:number level="any" format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:article">
      <xsl:if test="/d:set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ar</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:preface">
      <xsl:if test="/d:set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>pr</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:chapter">
      <xsl:if test="/d:set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ch</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:appendix">
      <xsl:if test="/d:set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:text>ap</xsl:text>
      <xsl:number level="any" format="a" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:part">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>pt</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:reference">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>rn</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:refentry">
      <xsl:choose>
        <xsl:when test="parent::d:reference">
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="/d:set">
            <!-- in a set, make sure we inherit the right book info... -->
            <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
              <xsl:with-param name="recursive" select="true()"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>re</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:colophon">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>co</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:sect1                     or self::d:sect2                     or self::d:sect3                     or self::d:sect4                     or self::d:sect5                     or self::d:section">
      <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
        <xsl:with-param name="recursive" select="true()"/>
      </xsl:apply-templates>
      <xsl:text>s</xsl:text>
      <xsl:number format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:bibliography">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>bi</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:glossary">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>go</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:index">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>ix</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:setindex">
      <xsl:text>si</xsl:text>
      <xsl:number level="any" format="01" from="d:set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="self::d:topic">
      <xsl:choose>
        <xsl:when test="/d:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="recursive-chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text>to</xsl:text>
      <xsl:number level="any" format="01" from="d:book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text>chunk-filename-error-</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:number level="any" format="01" from="d:set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Surely this template ought to be modified? I don't see how at the moment. -->
<xsl:template match="d:set|d:book|d:part|d:chapter|d:appendix
                      |d:article
                      |d:topic
                      |d:reference|d:refentry
                      |d:book/d:glossary|d:article/d:glossary|d:part/d:glossary
                      |d:book/d:bibliography|d:article/d:bibliography|d:part/d:bibliography
                      |d:colophon"
  priority="1">
  <xsl:choose>
    <xsl:when test="$onechunk != 0 and parent::*">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-chunk-element"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:preface" priority="1">
  <xsl:apply-imports/>
</xsl:template>


</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
