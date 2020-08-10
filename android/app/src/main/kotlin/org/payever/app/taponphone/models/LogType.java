package org.payever.app.taponphone.models;


public enum LogType {
    DEBUG("DEBUG"), INFO("INFO"), WARNING("WARNING"), ERROR("ERROR");

    private String mLogType;

    LogType(String logType) {
        mLogType = logType;
    }

    public String getLogType() {
        return mLogType;
    }

}
