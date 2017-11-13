<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exsl d"
                version="1.0">

  <xsl:import href="../neo/search.xsl" />
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml5/docbook.xsl" />
  <xsl:import href="../xhtml/html.xsl" />
  <xsl:import href="../xhtml/autotoc.xsl" />
  <xsl:import href="../xhtml/formal.xsl" />
  <xsl:import href="../xhtml/table.xsl" />
  <xsl:import href="../xhtml/lists.xsl" />
  <xsl:import href="../xhtml/glossary.xsl" />
  <xsl:import href="../xhtml/admon.xsl" />
  <xsl:import href="../components.xsl" />
  <xsl:import href="../xhtml/block.xsl" />
  <xsl:import href="../xhtml/sections.xsl" />
  <xsl:import href="../xhtml/callout.xsl" />
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk-common.xsl" />
  <xsl:import href="../xhtml/chunk-common.xsl" />
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml5/html5-chunk-mods.xsl" />
  <xsl:import href="html5-chunk-mods.xsl" />
  <xsl:import href="../xhtml/param.xsl" />
  <xsl:include href="../xhtml/verbatim.xsl" />
  <xsl:include href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk-code.xsl" />
  <xsl:include href="../xhtml/chunk-code.xsl" />

<!-- ============================================================ -->

  <xsl:template name="system.head.content">
    <xsl:param name="node" select="."/>

    <!-- CUSTOMIZATION: add meta tag (2016-07-27)
         The problem here is a combination of
         a) There seems to be no way to set encoding by parameter. (The
         documented chunker.output.encoding is ignored.) The remaining facility
         is to override user.head.content template.
         b) Scripts and stylesheets provided as html.stylesheet and html.script
         are included before the user.head.content template is applied. If
         there are many stylesheets and scripts the encoding meta tag will come
         late in the head. Browsers don't like that and some will force reload
         the page or behave as if encoding is not set at all.
         XXX: I'm not sure if other tags ending up late in the head is also
         problematic. The better solution is probably to move the
         parameter-provided scripts and stylesheets to a later template.
         -->
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <!-- END CUSTOMIZATION -->

    <!-- FIXME: When chunking, only the annotations actually used
                in this chunk should be referenced. I don't think it
                does any harm to reference them all, but it adds
                unnecessary bloat to each chunk. -->
    <xsl:if test="$annotation.support != 0 and //annotation">
      <xsl:call-template name="add.annotation.links"/>
      <script type="text/javascript">
        <xsl:text>// Create PopupWindow objects</xsl:text>
        <xsl:for-each select="//annotation">
          <xsl:text>var popup_</xsl:text>
          <xsl:value-of select="generate-id(.)"/>
          <xsl:text> = new PopupWindow("popup-</xsl:text>
          <xsl:value-of select="generate-id(.)"/>
          <xsl:text>");</xsl:text>
          <xsl:text>popup_</xsl:text>
          <xsl:value-of select="generate-id(.)"/>
          <xsl:text>.offsetY = 15;</xsl:text>
          <xsl:text>popup_</xsl:text>
          <xsl:value-of select="generate-id(.)"/>
          <xsl:text>.autoHide();</xsl:text>
        </xsl:for-each>
      </script>

      <style type="text/css">
        <xsl:value-of select="$annotation.css"/>
      </style>
    </xsl:if>

    <!-- system.head.content is like user.head.content, except that
        it is called before head.content. This is important because it
        means, for example, that <style> elements output by system.head.content
        have a lower CSS precedence than the users stylesheet. -->
  </xsl:template>

<!-- ============================================================ -->

  <xsl:template name="user.head.content">
    <xsl:param name="node" select="."/>

    <xsl:variable name="neo.frontpage.relpath">
      <xsl:call-template name="neo.frontpage.relpath" />
    </xsl:variable>

    <link rel="shortcut icon" href="https://neo4j.com/wp-content/themes/neo4jweb/favicon.ico"/>

    <script>
    $(document).ready(function() {
      CodeMirror.colorize();
      tabTheSource($('body'));
      var $header = $('header').first();
      $header.prepend(
        $('<a href="{$neo.frontpage.relpath}" id="logo"><img src="https://neo4j.com/wp-content/themes/neo4jweb/assets/images/neo4j-logo-2015.png" alt="Neo4j Logo"/></a>')
      );
      var $sidebar = $('<div id="sidebar-wrapper"/>');
      $.get('toc.html', function (d){
        $(d).appendTo($sidebar);
        highlightToc();
        highlightLibraryHeader();
      });
      $sidebar.insertAfter($('header').first());
    });
    </script>

    <xsl:if test="$neo.search != '0'">
      <xsl:call-template name="neo.search.headcss"/>
    </xsl:if>

  </xsl:template>

<!-- ============================================================ -->

  <xsl:template name="user.head.title">
    <xsl:param name="node" select="."/>
    <xsl:param name="title"/>

    <xsl:variable name="title.context">
      <xsl:apply-templates select=".." mode="object.title.markup.textonly"/>
    </xsl:variable>
    <title>
      <xsl:copy-of select="$title"/>
      <xsl:if test="parent::*">
        <xsl:text> - </xsl:text>
        <xsl:copy-of select="$title.context"/>
      </xsl:if>
    </title>
  </xsl:template>

<!-- ============================================================ -->

  <xsl:template name="head.content.abstract">
    <xsl:param name="node" select="."/>

    <xsl:variable name="abstract" select="($node/d:abstract | $node/d:preface/d:abstract)"/>

    <xsl:if test="$abstract">
      <meta name="description">
        <xsl:attribute name="content">
          <xsl:for-each select="$abstract[1]/*">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() &lt; last()">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </meta>
    </xsl:if>

    <!-- <xsl:message> -->
    <!--   <xsl:text>        [*] head.content.abstract</xsl:text> -->
    <!--   <xsl:value-of select="count($abstract)"/> -->
    <!-- </xsl:message> -->

  </xsl:template>

<!-- ============================================================ -->

  <xsl:template name="user.header.content">
    <xsl:param name="node" select="." />
    <xsl:if test="$neo.search != '0'">
      <xsl:call-template name="neo.search.searchresults" />
    </xsl:if>
  </xsl:template>

<!-- ============================================================ -->

  <xsl:template match="d:imagedata/@fileref" priority="1">
    <xsl:variable name="neo.frontpage.relpath">
      <xsl:call-template name="neo.frontpage.relpath">
        <xsl:with-param name="context" select=".." />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="imgsrc">
      <xsl:choose>
        <xsl:when test="contains(., '../')">
          <xsl:value-of select="concat($neo.frontpage.relpath, substring-after(., '../'))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($neo.frontpage.relpath, .)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$imgsrc" />
  </xsl:template>

<!-- ============================================================ -->

  <xsl:template name="neo.frontpage.relpath">
    <!-- Set $neo.frontpage.uri as the relative file path to the front page
         Set $neo.frontpage.dir as the relative dir path to the front page
         Useful for generating correct href:s for scripts and stylesheets.
      -->
    <xsl:param name="context" select="."/>
    <xsl:variable name="neo.frontpage.uri">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select="/" />
        <xsl:with-param name="context" select="$context" />
        <xsl:with-param name="neo.default.behavior" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$neo.frontpage.uri = 'index.html'">
        <xsl:text>./</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($neo.frontpage.uri, 'index.html')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
