<%--
  ~ Copyright 2000-2011 JetBrains s.r.o.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  --%>

<%@ taglib prefix="props" tagdir="/WEB-INF/tags/props" %>
<%@ taglib prefix="l" tagdir="/WEB-INF/tags/layout" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="bs" tagdir="/WEB-INF/tags" %>

<jsp:useBean id="propertiesBean" scope="request" type="jetbrains.buildServer.controllers.BasePropertiesBean"/>
<jsp:useBean id="constants" class="jetbrains.buildServer.fxcop.server.FxCopConstantsBean"/>

<l:settingsGroup title="FxCop Installation">

  <c:if test="${'auto' == propertiesBean.properties[constants.detectionModeKey]}">
    <c:set var="hidePathInput" value="style='display: none'"/>
  </c:if>

  <c:if test="${'manual' == propertiesBean.properties[constants.detectionModeKey]}">
    <c:set var="hideVersionInput" value="style='display: none'"/>
  </c:if>

  <tr>
    <th><label>FxCop detection mode:</label></th>
    <td>
      <c:set var="onclick">
        BS.Util.hide('pathInputSection');
        BS.Util.show('versionInputSection');
      </c:set>
      <props:radioButtonProperty name="${constants.detectionModeKey}"
                                 id="detectionModeAuto"
                                 value="${constants.detectionModeAuto}"
                                 checked="${constants.detectionModeAuto == propertiesBean.properties[constants.detectionModeKey]}"
                                 onclick="${onclick}" />
      <label for="detectionModeAuto">Autodetect installation</label>

      <span style="padding-left: 5em">
        <c:set var="onclick">
          BS.Util.show('pathInputSection');
          BS.Util.hide('versionInputSection');
        </c:set>
        <props:radioButtonProperty name="${constants.detectionModeKey}"
                                   id="detectionModeManual"
                                   value="${constants.detectionModeManual}"
                                   checked="${constants.detectionModeManual == propertiesBean.properties[constants.detectionModeKey]}"
                                   onclick="${onclick}"/>
        <label for="detectionModeManual">Specify installation root</label>
      </span>
    </td>
  </tr>

  <tr id="pathInputSection" ${hidePathInput}>
      <th><label for="${constants.rootKey}">Installation root: <l:star/></label></th>
      <td><props:textProperty name="${constants.rootKey}" className="longField"/>
        <span class="error" id="error_${constants.rootKey}"></span>
        <span class="smallNote">Specify path to FxCopCmd.exe home directory.</span>
      </td>
    </tr>

  <tr id="versionInputSection" ${hideVersionInput}>
    <th><label for="${constants.versionKey}">FxCop version: <bs:help file="FxCop" anchor="FxCopVersion"/></label></th>
    <td>
      <props:selectProperty name="${constants.versionKey}">
        <c:forEach var="item" items="${constants.avaliableVersions}">
          <props:option value="${item.technicalVersionPrefix}"><c:out value="${item.displayName}"/></props:option>
        </c:forEach>
      </props:selectProperty>
      <span class="error" id="error_${constants.versionKey}"></span>
      <span class="smallNote">Specify FxCop version required by the build. As a result agent requirement will be created. <br/>
                              Select 'Any Detected' to use any FxCop version autodetected on agent side.</span>
    </td>
  </tr>

</l:settingsGroup>

<l:settingsGroup title="What to inspect">
  <tr>
    <c:set var="onclick">
      $('${constants.projectKey}').disabled = this.checked;
      $('${constants.filesKey}').disabled = !this.checked;
      $('${constants.filesExcludeKey}').disabled = !this.checked;
      $('${constants.filesKey}').focus();
      BS.VisibilityHandlers.updateVisibility($('${constants.filesKey}'));
      BS.VisibilityHandlers.updateVisibility($('${constants.projectKey}'));
    </c:set>

    <th>
      <props:radioButtonProperty name="${constants.whatToInspectKey}"
                                 value="${constants.whatToInspectFilesValue}"
                                 id="mod-files"
                                 onclick="${onclick}"
                                 checked="${propertiesBean.properties[constants.whatToInspectKey] == constants.whatToInspectFilesValue}"/>
      <label for="mod-files">Assemblies: </label></th>
    <td><span>
      <props:multilineProperty name="${constants.filesKey}"
                               className="longField"
                               linkTitle="Type assembly files or wildcards"
                               cols="55" rows="5"
                               expanded="true"
                               disabled="${propertiesBean.properties[constants.whatToInspectKey] != constants.whatToInspectFilesValue}"/>
      <props:multilineProperty name="${constants.filesExcludeKey}"
                               className="longField"
                               linkTitle="Exclude assembly files by wildcard"
                               cols="55" rows="5"
                               expanded="false"
                               disabled="${propertiesBean.properties[constants.whatToInspectKey] != constants.whatToInspectFilesValue}"/>
      </span>
      <span class="smallNote">Assembly file names relative to checkout root separated by spaces.<br/>
        Ant-like wildcards are allowed.<br/>
        Example: bin\*.dll</span>
      <span class="error" id="error_${constants.filesKey}"></span>
      <span class="error" id="error_${constants.filesExcludeKey}"></span>
    </td>
  </tr>

  <tr>
    <c:set var="onclick">
      $('${constants.filesKey}').disabled = this.checked;
      $('${constants.filesExcludeKey}').disabled = this.checked;
      $('${constants.projectKey}').disabled = !this.checked;
      $('${constants.projectKey}').focus();
      BS.VisibilityHandlers.updateVisibility($('${constants.filesKey}'));
      BS.VisibilityHandlers.updateVisibility($('${constants.filesExcludeKey}'));
      BS.VisibilityHandlers.updateVisibility($('${constants.projectKey}'));
    </c:set>
    <th>
      <props:radioButtonProperty name="${constants.whatToInspectKey}"
                                 value="${constants.whatToInspectProjectValue}"
                                 id="mod-project"
                                 onclick="${onclick}"
                                 checked="${propertiesBean.properties[constants.whatToInspectKey] == constants.whatToInspectProjectValue}"/>
      <label for="mod-project">FxCop project file:</label></th>
    <td>
      <span>
        <props:textProperty name="${constants.projectKey}" className="longField"
                            disabled="${propertiesBean.properties[constants.whatToInspectKey] != constants.whatToInspectProjectValue}"/>
        </span>
      <span class="smallNote">FxCop project file name relative to checkout root</span>
      <span class="error" id="error_${constants.projectKey}"></span></td>
  </tr>

</l:settingsGroup>

<l:settingsGroup title="FxCop options">
  <tr>
    <th><label for="${constants.searchInGacKey}">Search referenced assemblies in GAC</label></th>
    <td>
      <props:checkboxProperty name="${constants.searchInGacKey}"/>
      <span class="error" id="error_${constants.searchInGacKey}"></span>
    </td>
  </tr>
  <tr>
    <th><label for="${constants.searchDirsKey}">Search referenced assemblies in directories</label></th>
    <td>
      <props:textProperty name="${constants.searchDirsKey}" className="longField"/>
      <span class="error" id="error_${constants.searchDirsKey}"></span>
      <span
          class="smallNote">List of directories (relative to checkout root and separated by spaces) to search referenced assemblies in.<br/>
      Sets /d: options for FxCopCmd</span>
    </td>
  </tr>
  <tr>
    <th><label for="${constants.ignoreGeneratedCodeKey}">Ignore generated code</label></th>
    <td>
      <props:checkboxProperty name="${constants.ignoreGeneratedCodeKey}"/>
      <span class="error" id="error_${constants.ignoreGeneratedCodeKey}"></span>
      <span class="smallNote">Sets /ignoregeneratedcode for FxCopCmd (note: it's supported since FxCop 1.36)</span>
    </td>
  </tr>
  <tr>
    <th><label for="${constants.reportXsltKey}">Report XSLT file:</label></th>
    <td><props:textProperty name="${constants.reportXsltKey}" className="longField"/>
      <span class="error" id="error_${constants.reportXsltKey}"></span>
      <span class="smallNote">XSLT file used to generate HTML report.<br/>
        Leave it empty to skip generation,<br/>
        set to '%system.FxCopRoot%/Xml/FxCopReport.xsl' to get standard FxCop report,<br/>
        or specify any custom file relative to checkout directory</span>
    </td>
  </tr>
  <tr>
    <th><label for="${constants.addtionalOptionsKey}">Additional FxCopCmd options: </label></th>
    <td><props:textProperty name="${constants.addtionalOptionsKey}" className="longField"/>
      <span class="error" id="error_${constants.addtionalOptionsKey}"></span>
      <span class="smallNote">Additional options to be added to FxCopCmd.exe command line</span>
    </td>
  </tr>
</l:settingsGroup>

<l:settingsGroup title="Build failure conditions">

  <tr>
    <th><label for="${constants.failOnAnalysisErrorKey}">Fail on analysis errors</label></th>
    <td>
      <props:checkboxProperty name="${constants.failOnAnalysisErrorKey}"/>
      <span class="error" id="error_${constants.failOnAnalysisErrorKey}"></span>
      <span class="smallNote">Fails build on analysis errors from FxCop such as:<br/>
        ANALYSIS_ERROR ASSEMBLY_LOAD_ERROR ASSEMBLY_REFERENCES_ERROR PROJECT_LOAD_ERROR RULE_LIBRARY_LOAD_ERROR UNKNOWN_ERROR OUTPUT_ERROR
      </span>
    </td>
  </tr>

  <tr>
    <c:url var="link" value="/admin/editBuildFailureConditions.html?init=1&id=${param['id']}"/>
    <th colspan="2">You can configure build to fail if it has too many inspection errors or warnings. To do it, add a corresponding
      <c:choose>
        <c:when test="${buildForm.createMode}">build failure condition. <bs:help file="Build+Failure+Conditions"/></c:when>
        <c:otherwise><a href="${link}">build failure condition</a>.</c:otherwise>
      </c:choose>
    </th>
  </tr>

</l:settingsGroup>
