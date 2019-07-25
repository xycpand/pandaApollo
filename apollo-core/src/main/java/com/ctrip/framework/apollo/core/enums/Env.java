package com.ctrip.framework.apollo.core.enums;

import com.google.common.base.Preconditions;

/**
 * Here is the brief description for all the predefined environments:
 * <ul>
 *   <li>LOCAL: Local Development environment, assume you are working at the beach with no network access</li>
 *   <li>DEV: Development environment</li>
 *   <li>FWS: Feature Web Service Test environment</li>
 *   <li>FAT: Feature Acceptance Test environment</li>
 *   <li>UAT: User Acceptance Test environment</li>
 *   <li>LPT: Load and Performance Test environment</li>
 *   <li>PRO: Production environment</li>
 *   <li>TOOLS: Tooling environment, a special area in production environment which allows
 * access to test environment, e.g. Apollo Portal should be deployed in tools environment</li>
 * </ul>
 *
 * @author Jason Song(song_s@ctrip.com)
 */
public enum Env{
  LOCAL, DEV, FWS, FAT, UAT, LPT, PRO,ZHUZHU, TOOLS, UNKNOWN,
  CZ ,
  ALPHA, //是内部测试版,一般不向外部发布,会有很多Bug.一般只有测试人员使用。
  BETA,  //也是测试版，这个阶段的版本会一直加入新的功能。在Alpha版之后推出。
  RC,    //   Release　Candidate 用在软件上就是候选版本。系统平台上就是发行候选版本。RC版不会再加入新的功能了，主要着重于除错。
  GA,    //General Availability,正式发布的版本，在国外都是用GA来说明release版本的。
  TEST,  // 测试环境，外部用户无法访问，专门给测试人员使用的，版本相对稳定。
  POC,   //Proof of Concept，针对客户具体应用的验证性测试
  SIT,   //System Integrate Test 系统整合测试（内测）
  PRE,   //灰度环境，外部用户可以访问，但是服务器配置相对低，其它和生产一样。
  PET    //Performance Evaluation Test 性能评估测试（压测）
 ;

  public static Env fromString(String env) {
    Env environment = EnvUtils.transformEnv(env);
    Preconditions.checkArgument(environment != UNKNOWN, String.format("Env %s is invalid", env));
    return environment;
  }
}
