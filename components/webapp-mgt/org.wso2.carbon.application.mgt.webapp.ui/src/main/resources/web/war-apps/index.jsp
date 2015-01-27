<!--
 ~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 ~
 ~ WSO2 Inc. licenses this file to you under the Apache License,
 ~ Version 2.0 (the "License"); you may not use this file except
 ~ in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~    http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing,
 ~ software distributed under the License is distributed on an
 ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 ~ KIND, either express or implied.  See the License for the
 ~ specific language governing permissions and limitations
 ~ under the License.
 -->
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.application.mgt.webapp.stub.types.carbon.WarCappMetadata" %>
<%@ page import="org.wso2.carbon.application.mgt.webapp.ui.WarAppAdminClient" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>

<!-- This page is included to display messages which are set to request scope or session scope -->
<jsp:include page="../dialog/display_messages.jsp"/>

<%
    String appName = (String) request.getAttribute("appName");

    String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext()
                    .getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);

    String BUNDLE = "org.wso2.carbon.application.mgt.webapp.ui.i18n.Resources";
    ResourceBundle bundle = ResourceBundle.getBundle(BUNDLE, request.getLocale());

    WarCappMetadata[] warMetadata = null;

    try {
        WarAppAdminClient client = new WarAppAdminClient(cookie,
                backendServerURL, configContext, request.getLocale());
        warMetadata = client.getWarAppData(appName);
    } catch (Exception e) {
        response.setStatus(500);
        CarbonUIMessage uiMsg = new CarbonUIMessage(CarbonUIMessage.ERROR, e.getMessage(), e);
        session.setAttribute(CarbonUIMessage.ID, uiMsg);
    }

%>

<fmt:bundle basename="org.wso2.carbon.application.mgt.webapp.ui.i18n.Resources">
    <%
        if (warMetadata != null && warMetadata.length > 0) {
    %>
    <p>&nbsp;&nbsp;</p>
    <table class="styledLeft" id="webappTable" width="60%">
        <thead>
        <tr>
            <th width="35%"><img src="../webapp-list/images/webapps.gif" alt="" style="vertical-align:middle;">&nbsp;<fmt:message key="carbonapps.webapp.web.application"/></th>
        </tr>
        </thead>
        <tbody>
        <%
            for (WarCappMetadata data : warMetadata) {
        %>
        <tr>
            <td><%= data.getWebappFileName()%></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        }
    %>

</fmt:bundle>
