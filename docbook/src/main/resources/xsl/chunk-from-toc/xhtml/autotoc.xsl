<?xml version="1.0"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

  <xsl:template name="make.toc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="toc.title.p" select="true()"/>
    <xsl:param name="nodes" select="/NOT-AN-ELEMENT"/>

    <xsl:variable name="nodes.plus" select="$nodes | d:qandaset"/>

    <xsl:variable name="toc.title">
      <xsl:if test="$toc.title.p">
        <xsl:choose>
          <xsl:when test="$make.clean.html != 0">
            <div class="toc-title">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key">TableofContents</xsl:with-param>
              </xsl:call-template>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <strong xmlns:xslo="http://www.w3.org/1999/XSL/Transform">
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key">TableofContents</xsl:with-param>
                </xsl:call-template>
              </strong>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$manual.toc != ''">
        <xsl:variable name="id">
          <xsl:call-template name="object.id"/>
        </xsl:variable>
        <xsl:variable name="toc" select="document($manual.toc, .)"/>
        <xsl:variable name="tocentry" select="$toc//d:tocentry[@linkend=$id]"/>
        <xsl:if test="$tocentry and $tocentry/*">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
              <xsl:call-template name="toc.list.attributes">
                <xsl:with-param name="toc-context" select="$toc-context"/>
                <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                <xsl:with-param name="nodes" select="$nodes"/>
              </xsl:call-template>
              <xsl:call-template name="manual-toc">
                <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
              </xsl:call-template>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$qanda.in.toc != 0">
            <xsl:if test="$nodes.plus">
              <div class="toc">
                <xsl:copy-of select="$toc.title"/>
                <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
                  <xsl:call-template name="toc.list.attributes">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                    <xsl:with-param name="nodes" select="$nodes"/>
                  </xsl:call-template>
                  <xsl:apply-templates select="$nodes.plus" mode="toc">
                    <xsl:with-param name="toc-context" select="$toc-context"/>
                  </xsl:apply-templates>
                </xsl:element>
              </div>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$nodes">
              <div class="toc">
                <xsl:copy-of select="$toc.title"/>
                <nav>
                  <xsl:attribute name="class">toc</xsl:attribute>
                  <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="toc.list.attributes">
                      <xsl:with-param name="toc-context" select="$toc-context"/>
                      <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
                      <xsl:with-param name="nodes" select="$nodes"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$nodes" mode="toc">
                      <xsl:with-param name="toc-context" select="$toc-context"/>
                    </xsl:apply-templates>
                  </xsl:element>
                </nav>
              </div>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
       CUSTOMIZATION added 2016-07-23
       Generate a complete table of contents on each page.
       -->
  <xsl:template name="component.toc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="toc.title.p" select="true()"/>

    <xsl:for-each select="ancestor::d:book">
      <xsl:call-template name="make.toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
        <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
        <xsl:with-param name="nodes" select="
            d:part|d:reference
            |d:preface|d:chapter|d:appendix
            |d:article
            |d:topic
            |d:bibliography|d:glossary|d:index
            |d:refentry
            |d:bridgehead[$bridgehead.in.toc != 0]"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>
  <!-- END CUSTOMIZATION -->

  <xsl:template name="section.toc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="toc.title.p" select="true()"/>

    <xsl:for-each select="ancestor::d:book">
      <xsl:call-template name="make.toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
        <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
        <xsl:with-param name="nodes" select="
            d:part|d:reference
            |d:preface|d:chapter|d:appendix
            |d:article
            |d:topic
            |d:bibliography|d:glossary|d:index
            |d:refentry
            |d:bridgehead[$bridgehead.in.toc != 0]"/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- <xsl:call-template name="make.toc"> -->
    <!--   <xsl:with-param name="toc-context" select="$toc-context"/> -->
    <!--   <xsl:with-param name="toc.title.p" select="$toc.title.p"/> -->
    <!--   <xsl:with-param name="nodes" select="section -->
    <!--     |sect1|sect2|sect3|sect4|sect5 -->
    <!--     |refentry -->
    <!--     |bridgehead[$bridgehead.in.toc != 0]"/> -->
    <!-- </xsl:call-template> -->

  </xsl:template>


</xsl:stylesheet>

<!-- vim: set sw=2 ts=2: -->
