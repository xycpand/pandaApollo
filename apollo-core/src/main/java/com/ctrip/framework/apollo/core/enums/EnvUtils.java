package com.ctrip.framework.apollo.core.enums;

import com.ctrip.framework.apollo.core.utils.StringUtils;

public final class EnvUtils {
  
  public static Env transformEnv(String envName) {
    if (StringUtils.isBlank(envName)) {
      return Env.UNKNOWN;
    }
    switch (envName.trim().toUpperCase()) {
      case "LPT":
        return Env.LPT;
      case "FAT":
      case "FWS":
        return Env.FAT;
      case "UAT":
        return Env.UAT;
      case "PRO":
      case "PROD": //just in case
        return Env.PRO;
      case "ZHUZHU":
          return Env.ZHUZHU;
      case "DEV":
        return Env.DEV;
      case "LOCAL":
        return Env.LOCAL;
      case "TOOLS":
        return Env.TOOLS;
      case "CZ":
          return Env.CZ;
      case "ALPHA":
          return Env.ALPHA;
      case "BETA":
          return Env.BETA;
      case "RC":
          return Env.RC;
      case "GA":
          return Env.GA;
      case "TEST":
          return Env.TEST;
      case "POC":
          return Env.POC;
      case "SIT":
          return Env.SIT;
      case "PRE":
          return Env.PRE;
      case "PET":
          return Env.PET;
      default:
        return Env.UNKNOWN;
    }
  }
}