<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0"
                exclude-result-prefixes="exsl cf d">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk-common.xsl"/>

<!-- ==================================================================== -->

  <xsl:template name="href.target">
    <xsl:param name="context" select="."/>
    <xsl:param name="object" select="."/>
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="neo.default.behavior" select="false()"/>
    <!-- * If $toc-context contains some node other than the current node, -->
    <!-- * it means we're processing a link in a TOC. In that case, to -->
    <!-- * ensure the link will work correctly, we need to take a look at -->
    <!-- * where the file containing the TOC will get written, and where -->
    <!-- * the file that's being linked to will get written. -->
    <xsl:variable name="toc-output-dir">
      <xsl:if test="not($toc-context = .)">
        <!-- * Get the $toc-context node and all its ancestors, look down -->
        <!-- * through them to find the last/closest node to the -->
        <!-- * toc-context node that has a "dbhtml dir" PI, and get the -->
        <!-- * directory name from that. That's the name of the directory -->
        <!-- * to which the current toc output file will get written. -->
        <xsl:call-template name="dbhtml-dir">
          <xsl:with-param name="context" select="$toc-context/ancestor-or-self::*[processing-instruction('dbhtml')[contains(.,'dir')]][last()]"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="linked-file-output-dir">
      <xsl:if test="not($toc-context = .)">
        <!-- * Get the current node and all its ancestors, look down -->
        <!-- * through them to find the last/closest node to the current -->
        <!-- * node that has a "dbhtml dir" PI, and get the directory name -->
        <!-- * from that.  That's the name of the directory to which the -->
        <!-- * file that's being linked to will get written. -->
        <xsl:call-template name="dbhtml-dir">
          <xsl:with-param name="context" select="ancestor-or-self::*[processing-instruction('dbhtml')[contains(.,'dir')]][last()]"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="href.to.uri">
      <xsl:call-template name="href.target.uri">
        <xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="href.from.uri">
      <xsl:choose>
        <xsl:when test="not($toc-context = .)">
          <xsl:call-template name="href.target.uri">
            <xsl:with-param name="object" select="$toc-context"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="href.target.uri">
            <xsl:with-param name="object" select="$context"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- * <xsl:message>toc-context: <xsl:value-of select="local-name($toc-context)"/></xsl:message> -->
    <!-- * <xsl:message>node: <xsl:value-of select="local-name(.)"/></xsl:message> -->
    <!-- * <xsl:message>context: <xsl:value-of select="local-name($context)"/></xsl:message> -->
    <!-- * <xsl:message>object: <xsl:value-of select="local-name($object)"/></xsl:message> -->
    <!-- * <xsl:message>toc-output-dir: <xsl:value-of select="$toc-output-dir"/></xsl:message> -->
    <!-- * <xsl:message>linked-file-output-dir: <xsl:value-of select="$linked-file-output-dir"/></xsl:message> -->
    <!-- * <xsl:message>href.to.uri: <xsl:value-of select="$href.to.uri"/></xsl:message> -->
    <!-- * <xsl:message>href.from.uri: <xsl:value-of select="$href.from.uri"/></xsl:message> -->
    <xsl:variable name="href.to">
      <xsl:choose>
        <!-- * 2007-07-19, MikeSmith: Added the following conditional to -->
        <!-- * deal with a problem case for links in TOCs. It checks to see -->
        <!-- * if the output dir that a TOC will get written to is -->
        <!-- * different from the output dir of the file being linked to. -->
        <!-- * If it is different, we do not call trim.common.uri.paths. -->
        <!-- *  -->
        <!-- * Reason why I added that conditional is: I ran into a bug for -->
        <!-- * this case: -->
        <!-- *  -->
        <!-- * 1. we are chunking into separate dirs -->
        <!-- *  -->
        <!-- * 2. output for the TOC is written to current dir, but the file -->
        <!-- *    being linked to is written to some subdir "foo". -->
        <!-- *  -->
        <!-- * For that case, links to that file in that TOC did not show -->
        <!-- * the correct path - they omitted the "foo". -->
        <!-- *  -->
        <!-- * The cause of that problem was that the trim.common.uri.paths -->
        <!-- * template[1] was being called under all conditions. But it's -->
        <!-- * apparent that we don't want to call trim.common.uri.paths in -->
        <!-- * the case where a linked file is being written to a different -->
        <!-- * directory than the TOC that contains the link, because doing -->
        <!-- * so will cause a necessary (not redundant) directory-name -->
        <!-- * part of the link to get inadvertently trimmed, resulting in -->
        <!-- * a broken link to that file. Thus, added the conditional. -->
        <!-- *  -->
        <!-- * [1] The purpose of the trim.common.uri.paths template is to -->
        <!-- * prevent cases where, if we didn't call it, we end up with -->
        <!-- * unnecessary, redundant directory names getting output; for -->
        <!-- * example, "foo/foo/refname.html". -->
        <xsl:when test="not($toc-output-dir = $linked-file-output-dir)">
          <xsl:value-of select="$href.to.uri"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="trim.common.uri.paths">
            <xsl:with-param name="uriA" select="$href.to.uri"/>
            <xsl:with-param name="uriB" select="$href.from.uri"/>
            <xsl:with-param name="return" select="'A'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="href.from">
      <xsl:call-template name="trim.common.uri.paths">
        <xsl:with-param name="uriA" select="$href.to.uri"/>
        <xsl:with-param name="uriB" select="$href.from.uri"/>
        <xsl:with-param name="return" select="'B'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="depth">
      <xsl:call-template name="count.uri.path.depth">
        <xsl:with-param name="filename" select="$href.from"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="href">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string" select="'../'"/>
        <xsl:with-param name="count" select="$depth"/>
      </xsl:call-template>
      <xsl:value-of select="$href.to"/>
    </xsl:variable>
    <!--
    <xsl:message>
      <xsl:text>In </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$href.from"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="$depth"/>
      <xsl:text>) </xsl:text>
      <xsl:value-of select="name($object)"/>
      <xsl:text> href=</xsl:text>
      <xsl:value-of select="$href"/>
    </xsl:message>
    -->

    <xsl:choose>
      <xsl:when test="$neo.default.behavior">
        <xsl:value-of select="$href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="neo.path">
          <xsl:value-of select="substring-before($href, 'index.html')"/>
        </xsl:variable>
        <xsl:variable name="neo.fragment">
          <xsl:choose>
            <xsl:when test="contains($href, '#')">
              <xsl:value-of select="concat('#', substring-after($href, '#'))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="''"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="concat($neo.path, $neo.fragment)"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:value-of select="string-join((substring-before($href, 'index.html'),substring-after($href, 'index.html')),'#')"/> -->

  </xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
