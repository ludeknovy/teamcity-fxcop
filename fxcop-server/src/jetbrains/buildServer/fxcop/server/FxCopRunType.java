/*
 * Copyright 2000-2010 JetBrains s.r.o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package jetbrains.buildServer.fxcop.server;

import java.util.HashMap;
import java.util.Map;
import jetbrains.buildServer.fxcop.common.FxCopConstants;
import jetbrains.buildServer.serverSide.PropertiesProcessor;
import jetbrains.buildServer.serverSide.RunType;
import jetbrains.buildServer.serverSide.RunTypeRegistry;
import jetbrains.buildServer.util.StringUtil;
import org.jetbrains.annotations.NotNull;

public class FxCopRunType extends RunType {
  public FxCopRunType(final RunTypeRegistry runTypeRegistry) {
    runTypeRegistry.registerRunType(this);
  }

  @Override
  public PropertiesProcessor getRunnerPropertiesProcessor() {
    return new FxCopRunTypePropertiesProcessor();
  }

  @Override
  public String getDescription() {
    return FxCopConstants.RUNNER_DESCRIPTION;
  }

  @Override
  public String getEditRunnerParamsJspFilePath() {
    return "editFxCopRunParams.jsp";
  }

  @Override
  public String getViewRunnerParamsJspFilePath() {
    return "viewFxcopRunParams.jsp";
  }

  @Override
  public Map<String, String> getDefaultRunnerProperties() {
    Map<String, String> map = new HashMap<String, String>();
    setUpDefaultParams(map);

    return map;
  }

  @Override
  @NotNull
  public String getType() {
    return FxCopConstants.RUNNER_TYPE;
  }

  @Override
  public String getDisplayName() {
    return FxCopConstants.RUNNER_DISPLAY_NAME;
  }

  private static void setUpDefaultParams(Map<String, String> parameters) {
    parameters.put(
      FxCopConstants.SETTINGS_FXCOP_ROOT,
      "%" + FxCopConstants.FXCOP_ROOT_PROPERTY + "%");
    parameters.put(
      FxCopConstants.SETTINGS_WHAT_TO_INSPECT, FxCopConstants.WHAT_TO_INSPECT_FILES);
    parameters.put(FxCopConstants.SETTINGS_SEARCH_IN_GAC, "true");
    parameters.put(FxCopConstants.SETTINGS_FAIL_ON_ANALYSIS_ERROR, "true");
  }

  @NotNull
  @Override
  public String getShortDescription(@NotNull final Map<String, String> runnerParams) {
    StringBuilder result = new StringBuilder();
    String what = runnerParams.get(FxCopConstants.SETTINGS_WHAT_TO_INSPECT);
    if (what == null || "files".equals(what)) {
      result.append("Assemblies: ").append(StringUtil.emptyIfNull(runnerParams.get(FxCopConstants.SETTINGS_FILES)));
    } else {
      result.append("FxCop project: ").append(StringUtil.emptyIfNull(runnerParams.get(FxCopConstants.SETTINGS_PROJECT)));
    }
    return result.toString();
  }
}
