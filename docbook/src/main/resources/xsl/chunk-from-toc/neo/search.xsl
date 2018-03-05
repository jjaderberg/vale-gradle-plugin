<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:gcse="http://google.com/gcse"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0"
                exclude-result-prefixes="gcse d">

<!-- ============================================================ -->

  <xsl:param name="neo.search" select="0" />

  <xsl:param name="neo.newsearch" select="0" />

  <xsl:template name="neo.newsearch.searchbox">
    <div class="searchbox">
      <form id="search-form" class="search" name="search-form" role="search">
        <input id="search-form-input"
               name="q"
               title="search"
               type="search"
               lang="en"
               placeholder="Search Neo4j docs..."
               aria-label="Search Neo4j documentation"
               max-length="128"
               required="required" />
        <input id="search-form-button" type="submit" value="Search" />
      </form>
    </div>
  </xsl:template>

  <xsl:template name="neo.newsearch.searchresults">
    <div id="search-results" class="hidden">
    </div>
  </xsl:template>

  <xsl:template name="neo.search.searchbox">
    <div class="gcse searchbox">
      <script>
        (function() {
          var cx = '002064766527965027360:amnud1nv_ga';
          var gcse = document.createElement('script');
          gcse.type = 'text/javascript';
          gcse.async = true;
          gcse.src = 'https://cse.google.com/cse.js?cx=' + cx;
          var s = document.getElementsByTagName('script')[0];
          s.parentNode.insertBefore(gcse, s);
        })();
      </script>
    <gcse:searchbox></gcse:searchbox>
    </div>
  </xsl:template>

  <xsl:template name="neo.search.searchresults">
    <div class="gcse search-results">
      <gcse:searchresults></gcse:searchresults>
    </div>
  </xsl:template>

  <xsl:template name="neo.search.headcss">
    <xsl:text disable-output-escaping="yes"><![CDATA[<style type="text/css">

      /* Search form */
        table.gsc-search-box td.gsc-input {
          border-color: #BBBBBB;
          border-radius: 4px !important;
          padding-right: 3px !important;
        }
        table.gsc-search-box td.gsc-input > input {
          border-color: #BBBBBB;
          border-radius: 4px !important;
        }
        /* END Search form */

        div.gcse table td {
          border: 0;
        }

        /* Results */
        div.search-results {
          width: 100%;
          margin-left: auto;
          margin-right: auto;
          margin-top: 0;
          margin-bottom: 0;
          *zoom: 1;
          position: relative;
          max-width: 940px;
        }
        div.gsc-results-wrapper-visible {
          padding-top: 140px;
        }
        div.gsc-url-top {
          display: none;
        }
        div.gsc-url-bottom {
          display: none;
        }
        table.gsc-table-result {
          margin-bottom: 0px;
        }
        .gs-webResult.gs-result a.gs-title:link, .gs-webResult.gs-result a.gs-title:link b {
          text-decoration: none !important;
        }
        .gs-result .gs-title {
          text-decoration: none !important;
        }
        .gs-webResult div.gs-per-result-labels a.gs-label {
          color: #428bca !important;
          text-decoration: none !important;
        }
        /* END Results */

        /* Paged results */
        .gsc-results .gsc-cursor-box > .gsc-cursor > .gsc-cursor-current-page {
          border: 1px solid #4183C4;
          border-radius: 4px;
          background-color: #ffffff;
          text-shadow: none;
        }
        .gsc-results .gsc-cursor-box > .gsc-cursor > .gsc-cursor-page {
          text-decoration: none;
          color: #4183C4;
        }
        /* END paged results */

        /* Label tabs */
        .gsc-tabsArea {
          border-bottom-width: 0px !important;
        }
        .gsc-tabsArea .gs-spacer {
          display: none !important;
        }
        .gsc-tabHeader {
          margin: 0 !important;
        }
        .cse .gsc-tabHeader.gsc-tabhActive, .gsc-tabHeader.gsc-tabhActive {
          font-family: "Open Sans", "DejaVu Sans", sans-serif;
          font-weight: normal;
          font-size: 12px;
          text-transform: none;
          color: #555 !important;
          cursor: default !important;
          background-color: #fff !important;
          border: 1px solid #ddd !important;
          border-bottom-color: transparent !important;
          line-height: 1.42857143 !important;
          border-radius: 4px 4px 0 0 !important;
          padding: 10px 13px !important;
        }
        .gsc-tabHeader.gsc-tabhInactive {
          font-family: "Open Sans", "DejaVu Sans", sans-serif;
          font-weight: normal;
          font-size: 12px;
          text-transform: none;
          color: #555 !important;
          background-color: #fff !important;
          line-height: 1.42857143 !important;
          border: 1px solid transparent !important;
          border-bottom-color: #ddd !important;
          border-radius: 4px 4px 0 0 !important;
          padding: 10px 13px !important;
        }
      </style>]]></xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set sw=2 ts=2: -->
