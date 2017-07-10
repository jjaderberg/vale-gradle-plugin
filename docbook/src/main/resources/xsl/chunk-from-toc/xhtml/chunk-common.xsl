<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0"
                xmlns:ssb="http://sideshowbarker.net/ns"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0"
                exclude-result-prefixes="exsl cf d">

  <xsl:param name="neo.documentation.library.links">
Developer Manual=https://neo4j.com/docs/developer-manual/current/
Operations Manual=https://neo4j.com/docs/operations-manual/current/
OGM Manual=https://neo4j.com/docs/ogm-manual/current/
Java Developer Reference=https://neo4j.com/docs/java-reference/current/
REST Docs=https://neo4j.com/docs/rest-docs/current/
  </xsl:param>

<!-- ==================================================================== -->

  <xsl:template name="process-chunk">
    <xsl:param name="prev" select="."/>
    <xsl:param name="next" select="."/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>

    <xsl:variable name="ischunk">
      <xsl:call-template name="chunk"/>
    </xsl:variable>

    <xsl:variable name="chunkfn">
      <xsl:if test="$ischunk='1'">
        <xsl:apply-templates mode="chunk-filename" select="."/>
      </xsl:if>
    </xsl:variable>

    <xsl:if test="$ischunk='0'">
      <xsl:message>
        <xsl:text>Error </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text> is not a chunk!</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="filename">
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
        <xsl:with-param name="base.name" select="$chunkfn"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- <xsl:message> -->
    <!--   <xsl:text>    [-] $chunk.base.dir=</xsl:text> -->
    <!--   <xsl:value-of select="$chunk.base.dir" /> -->
    <!--   <xsl:text>, $chunkfn=</xsl:text> -->
    <!--   <xsl:value-of select="$chunkfn" /> -->
    <!--   <xsl:text>, $filename=</xsl:text> -->
    <!--   <xsl:value-of select="$filename" /> -->
    <!-- </xsl:message> -->

    <!-- CUSTOMIZATOIN:
         This bit was added to create a document-global table of contents for
         each chunk, but store it in a separate file. Alongside each chunk,
         stored as 'some/path/index.html', there will be a 'some/path/toc.html'.
         This can then be loaded dynamically into the page.
         -->
    <xsl:variable name="toc-context" select="."/>
    <xsl:variable name="toc.title.p" select="true()"/>
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="concat(substring-before($filename, 'index.html'), 'toc.html')"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:for-each select="ancestor-or-self::d:book">
          <xsl:call-template name="make.toc">
            <xsl:with-param name="toc-context" select="$toc-context" />
            <xsl:with-param name="toc.title.p" select="$toc.title.p" />
            <xsl:with-param name="nodes" select="
                d:part|d:reference
                |d:chapter|d:appendix
                |d:article
                |d:topic
                |d:bibliography|d:glossary|d:index
                |d:refentry
                |d:bridgehead[$bridgehead.in.toc != 0]"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
    </xsl:call-template>
    <!-- END CUSTOMIZATION -->

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="content">
        <xsl:call-template name="chunk-element-content">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
    </xsl:call-template>
  </xsl:template>

<!-- ==================================================================== -->

<!-- ==================================================================== -->

  <xsl:template name="header.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template name="user.header.navigation">
    <xsl:param name="node" select="."/>
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>
    <xsl:variable name="row2"
                  select="count($prev) &gt; 0 or (count($up) &gt; 0 and generate-id($up) != generate-id($home) and $navig.showtitles != 0) or count($next) &gt; 0"/>

    <xsl:call-template name="neo.documentation.library.header" />

    <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
      <nav id="header-nav">

        <xsl:if test="$row2">

          <span class="nav-previous">
            <xsl:if test="count($prev)&gt;0">
              <a accesskey="p">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$prev"/>
                  </xsl:call-template>
                </xsl:attribute>
                <span class="fa fa-long-arrow-left" aria-hidden="true"></span>
                <xsl:choose>
                  <xsl:when test="$navig.showtitles != 0">
                    <xsl:apply-templates select="$prev" mode="titleabbrev.markup"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'prev'"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </xsl:if>
          </span>

          <span class="nav-current">
            <p class="nav-title hidden">
              <xsl:apply-templates select="." mode="object.title.markup"/>
            </p>
          </span>

          <span class="nav-next">
            <xsl:if test="count($next)&gt;0">
              <a accesskey="n">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$next"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$navig.showtitles != 0">
                    <xsl:apply-templates select="$next" mode="titleabbrev.markup"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'next'"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                <span class="fa fa-long-arrow-right" aria-hidden="true"></span>
              </a>
            </xsl:if>
          </span>


        </xsl:if>

      </nav>
    </xsl:if>

    <xsl:if test="$header.rule != 0">
      <hr/>
    </xsl:if>
  </xsl:template>

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

<!-- <xsl:message> -->
<!--   <xsl:text>    [xxx] 2: </xsl:text> -->
<!--   <xsl:value-of select="$toc-output-dir" /> -->
<!--   <xsl:text>  ::  </xsl:text> -->
<!--   <xsl:value-of select="$linked-file-output-dir" /> -->
<!--   <xsl:text>  ::  </xsl:text> -->
<!--   <xsl:value-of select="$href.to.uri" /> -->
<!--   <xsl:text>  ::  </xsl:text> -->
<!--   <xsl:value-of select="$href.from.uri" /> -->
<!--   <xsl:text>  ::  </xsl:text> -->
<!--   <xsl:value-of select="$depth" /> -->
<!--   <xsl:text>  ::  </xsl:text> -->
<!--   <xsl:value-of select="$href" /> -->
<!-- </xsl:message> -->

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

  <xsl:template name="neo.documentation.library.header">

    <xsl:variable name="_links">
      <xsl:call-template name="str.tokenize.keep.delimiters">
        <xsl:with-param name="string" select="normalize-space($neo.documentation.library.links)" />
        <xsl:with-param name="delimiters" select="' '" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="count(exsl:node-set($_links))">
      <ul>
        <xsl:attribute name="class">documentation-library</xsl:attribute>

        <xsl:for-each select="exsl:node-set($_links)/ssb:token">
          <xsl:variable name="_pair">
            <xsl:call-template name="str.tokenize.keep.delimiters">
              <xsl:with-param name="string" select="." />
              <xsl:with-param name="delimiters" select="'='" />
            </xsl:call-template>
          </xsl:variable>
          <li>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="exsl:node-set($_pair)/ssb:token[2]" />
              </xsl:attribute>
              <xsl:call-template name="string.subst">
                <xsl:with-param name="string" select="exsl:node-set($_pair)/ssb:token[1]" />
                <xsl:with-param name="target" select="'_'" />
                <xsl:with-param name="replacement" select="' '" />
              </xsl:call-template>
            </a>
          </li>
        </xsl:for-each>

      </ul>
    </xsl:if>

  </xsl:template>

<!-- ==================================================================== -->
</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
