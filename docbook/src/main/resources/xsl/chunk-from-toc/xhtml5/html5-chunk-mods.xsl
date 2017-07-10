<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exsl d"
                version="1.0">


<!-- ============================================================ -->

  <!-- Add HTML5 <header>  wrapper, and convert some attributes to styles -->
  <xsl:template name="html5.header.navigation">
    <xsl:param name="prev" select="/d:foo"/>
    <xsl:param name="next" select="/d:foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="content">
      <xsl:call-template name="user.header.navigation">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="nav.context" select="$nav.context"/>
      </xsl:call-template>

      <xsl:call-template name="header.navigation">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="nav.context" select="$nav.context"/>
      </xsl:call-template>
    </xsl:variable>

    <header>
      <xsl:call-template name="neo.search.searchbox" />
      <!-- And fix up any style atts -->
      <xsl:call-template name="convert.styles">
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
    </header>
  </xsl:template>

<!-- ============================================================ -->

  <!-- Add HTML5 <footer>  wrapper, and convert some attributes to styles -->
  <xsl:template name="html5.footer.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="content">
      <footer>
        <!-- Google Universal Tracker -->
        <script type="text/javascript">
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
          //Allow Linker
          ga('create', 'UA-1192232-34','auto', {'allowLinker': true});
          ga('send', 'pageview');
          // Load the plugin.
          ga('require', 'linker');
          // Define which domains to autoLink.
          ga('linker:autoLink', ['neo4j.org','neo4j.com','neotechnology.com','graphdatabases.com','graphconnect.com']);
        </script>
        <!-- END Google Universal Tracker -->
        <script type="text/javascript">
          document.write(unescape("%3Cscript src='//munchkin.marketo.net/munchkin.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script>Munchkin.init('773-GON-065');</script>
      </footer>
    </xsl:variable>

    <!-- And fix up any style atts -->
    <xsl:call-template name="convert.styles">
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set ts=2 sw=2: -->
