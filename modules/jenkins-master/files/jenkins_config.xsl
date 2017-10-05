<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- Identity transform -->
<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="/hudson/clouds">
	<clouds>
		<xsl:copy-of select="document('yet-another-docker-plugin_config.xml')"/>
	</clouds>
</xsl:template>

<xsl:template match="/hudson/slaveAgentPort">
	<slaveAgentPort>0</slaveAgentPort>
	<disabledAgentProtocols>
		<string>JNLP-connect</string>
		<string>JNLP2-connect</string>
	</disabledAgentProtocols>
</xsl:template>

</xsl:stylesheet>