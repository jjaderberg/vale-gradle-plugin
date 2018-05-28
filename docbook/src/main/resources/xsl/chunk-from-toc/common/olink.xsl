<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- Created: 2018-05-28
       Context: We put HTML files in nested directories, all files are named index.html.
         This means the href attribute is the empty string for the root chunk / front page of a doc set.
         The output file in that case is index.html in the output root directory.
         The current selection logic for olink target lookups asserts that href is non-empty.
         That means we cannot refer to the root element for a piece of content in an olink.
         It is falsely said not to exist, because the href attribute is empty.

         Below, rather than testing that href is empty, we test whether the href attribute exists.-->

  <!-- Locate olink key in a particular language -->
  <xsl:template name="select.olink.key.in.lang">
    <xsl:param name="targetdoc.att" select="''"/>
    <xsl:param name="targetptr.att" select="''"/>
    <xsl:param name="olink.lang" select="''"/>
    <xsl:param name="target.database"/>
    <xsl:param name="fallback.index" select="1"/>
    <xsl:param name="olink.fallback.sequence" select="''"/>

    <xsl:variable name="target.lang">
      <xsl:call-template name="select.target.lang">
        <xsl:with-param name="fallback.index" select="$fallback.index"/>
        <xsl:with-param name="olink.fallback.sequence"
                        select="$olink.fallback.sequence"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$olink.debug != 0">
      <xsl:message><xsl:text>Olink debug: cases for targetdoc='</xsl:text>
        <xsl:value-of select="$targetdoc.att"/>
        <xsl:text>' and targetptr='</xsl:text>
        <xsl:value-of select="$targetptr.att"/>
        <xsl:text>' in language '</xsl:text>
        <xsl:value-of select="$target.lang"/>
        <xsl:text>'.</xsl:text>
      </xsl:message>
    </xsl:if>

    <!-- Customize these cases if you want different selection logic -->
    <xsl:variable name="CaseA">
      <!-- targetdoc.att = not blank
          targetptr.att = not blank
      -->
      <xsl:if test="$targetdoc.att != '' and
                    $targetptr.att != ''">
        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat($targetdoc.att, '/', 
                                      $targetptr.att, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href" >
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseA matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseA NOT matched</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="CaseB">
      <!-- targetdoc.att = not blank
          targetptr.att = not blank
          prefer.internal.olink = not zero
          current.docid = not blank 
      -->
      <xsl:if test="$targetdoc.att != '' and
                    $targetptr.att != '' and
                    $current.docid != '' and
                    $prefer.internal.olink != 0">
        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat($current.docid, '/', 
                                      $targetptr.att, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href != ''">
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseB matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseB NOT matched</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="CaseC">
      <!-- targetdoc.att = blank
          targetptr.att = not blank
          current.docid = not blank 
      -->
      <xsl:if test="string-length($targetdoc.att) = 0 and
                    $targetptr.att != '' and
                    $current.docid != ''">
        <!-- Must use a for-each to change context for keys to work -->
        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat($current.docid, '/', 
                                      $targetptr.att, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href != ''">
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseC matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseC NOT matched.</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="CaseD">
      <!-- targetdoc.att = blank
          targetptr.att = not blank
          current.docid = blank 
      -->
      <!-- This is possible if only one document in the database -->
      <xsl:if test="string-length($targetdoc.att) = 0 and
                    $targetptr.att != '' and
                    string-length($current.docid) = 0 and
                    count($target.database//document) = 1">
        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat(.//document/@targetdoc, '/', 
                                      $targetptr.att, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href != ''">
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseD matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseD NOT matched</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="CaseE">
      <!-- targetdoc.att = not blank
          targetptr.att = blank
      -->
      <xsl:if test="$targetdoc.att != '' and
                    string-length($targetptr.att) = 0">

        <!-- Try the document's root element id -->
        <xsl:variable name="rootid">
          <xsl:choose>
            <xsl:when test="$target.lang != ''">
              <xsl:value-of select="$target.database//document[@targetdoc = $targetdoc.att and @lang = $target.lang]/*[1]/@targetptr"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$target.database//document[@targetdoc = $targetdoc.att and not(@lang)]/*[1]/@targetptr"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat($targetdoc.att, '/', 
                                      $rootid, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href != ''">
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseE matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseE NOT matched.</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="CaseF">
      <!-- targetdoc.att = not blank
          targetptr.att = blank
          prefer.internal.olink = not zero
          current.docid = not blank 
      -->
      <xsl:if test="$targetdoc.att != '' and
                    string-length($targetptr.att) = 0 and
                    $current.docid != '' and
                    $prefer.internal.olink != 0">
        <!-- Try the document's root element id -->
        <xsl:variable name="rootid">
          <xsl:choose>
            <xsl:when test="$target.lang != ''">
              <xsl:value-of select="$target.database//document[@targetdoc = $current.docid and @lang = $target.lang]/*[1]/@targetptr"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$target.database//document[@targetdoc = $current.docid and not(@lang)]/*[1]/@targetptr"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:for-each select="$target.database">
          <xsl:variable name="key" 
                        select="concat($current.docid, '/', 
                                      $rootid, '/',
                                      $target.lang)"/>
          <xsl:choose>
            <xsl:when test="key('targetptr-key', $key)[1]/@href != ''">
              <xsl:value-of select="$key"/>
              <xsl:if test="$olink.debug != 0">
                <xsl:message>Olink debug: CaseF matched.</xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:when test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseF NOT matched.</xsl:message>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>

    <!-- Now select the best match. Customize the order if needed -->
    <xsl:variable name="selected.key">
      <xsl:choose>
        <xsl:when test="$CaseB != ''">
          <xsl:value-of select="$CaseB"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseB key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseB"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$CaseA != ''">
          <xsl:value-of select="$CaseA"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseA key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseA"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$CaseC != ''">
          <xsl:value-of select="$CaseC"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseC key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseC"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$CaseD != ''">
          <xsl:value-of select="$CaseD"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseD key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseD"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$CaseF != ''">
          <xsl:value-of select="$CaseF"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseF key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseF"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$CaseE != ''">
          <xsl:value-of select="$CaseE"/>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: CaseE key is the final selection: </xsl:text>
              <xsl:value-of select="$CaseE"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: No case matched for lang '</xsl:text>
              <xsl:value-of select="$target.lang"/>
              <xsl:text>'.</xsl:text>
            </xsl:message>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$selected.key != ''">
        <xsl:value-of select="$selected.key"/>
      </xsl:when>
      <xsl:when test="string-length($selected.key) = 0 and 
                      string-length($target.lang) = 0">
        <!-- No match on last try, and we are done -->
      </xsl:when>
      <xsl:otherwise>
        <!-- Recurse through next language -->
        <xsl:call-template name="select.olink.key.in.lang">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="fallback.index" select="$fallback.index + 1"/>
          <xsl:with-param name="olink.fallback.sequence"
                          select="$olink.fallback.sequence"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
