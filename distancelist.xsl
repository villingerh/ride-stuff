<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ns3="http://www.garmin.com/xmlschemas/ActivityExtension/v2"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:ckbk="http://math.function/"
        xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:param name="Latitude" />
    <xsl:param name="Longitude" />

    <xsl:output method="text" />

    <!-- Quadratwurzel -->
    <xsl:function
            name="ckbk:sqrt"
            as="xs:double">
        <xsl:param
                name="number"
                as="xs:double" />
        <xsl:variable
                name="try"
                select="if ($number lt 100.0) then 1.0 else if ($number gt 100.0 and $number lt 1000.0) then 10.0 else if ($number gt 1000.0 and $number lt 10000.0) then 31.0 else 100.00"
                as="xs:decimal" />
        <xsl:sequence select="if ($number ge 0) then ckbk:sqrt($number,$try,1,20) else xs:double('NaN')" />
    </xsl:function>
    <xsl:function
            name="ckbk:sqrt"
            as="xs:double">
        <xsl:param
                name="number"
                as="xs:double" />
        <xsl:param
                name="try"
                as="xs:double" />
        <xsl:param
                name="iter"
                as="xs:integer" />
        <xsl:param
                name="maxiter"
                as="xs:integer" />
        <xsl:variable
                name="result"
                select="$try * $try"
                as="xs:double" />
        <xsl:sequence select="if ($result eq $number or $iter gt $maxiter) then $try else ckbk:sqrt($number, ($try - (($result - $number) div (2 * $try))), $iter + 1, $maxiter)" />
    </xsl:function>

    <xsl:template match="//Trackpoint">
        <xsl:if test="not(Position/LatitudeDegrees = -999)">
            <xsl:variable name="LatDif">
                <xsl:value-of select="$Latitude - Position/LatitudeDegrees" />
            </xsl:variable>
            <xsl:variable name="LonDif">
                <xsl:value-of select="$Longitude - Position/LongitudeDegrees" />
            </xsl:variable>
            <xsl:variable name="dist">
                <xsl:value-of select="ckbk:sqrt(xs:double(($LatDif * $LatDif) + ($LonDif * $LonDif)))" />
            </xsl:variable>
            <xsl:value-of select="fn:replace($dist, '\.', ',')" />
            <xsl:text>;</xsl:text>
            <xsl:value-of select="Extensions/ns3:TPX/Speed"></xsl:value-of>
            <xsl:text>&#xa;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:apply-templates />
    </xsl:template>
</xsl:stylesheet>