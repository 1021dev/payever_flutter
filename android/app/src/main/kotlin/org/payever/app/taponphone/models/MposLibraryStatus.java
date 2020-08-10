package org.payever.app.taponphone.models;

public class MposLibraryStatus {

    private String status;
    private String currentInterface;
    private String additionalInfo;
    private String libraryInfo;
    private String defaultCounty;
    private String defaultCurrency;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCurrentInterface() {
        return currentInterface;
    }

    public void setCurrentInterface(String currentInterface) {
        this.currentInterface = currentInterface;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getLibraryInfo() {
        return libraryInfo;
    }

    public void setLibraryInfo(String libraryInfo) {
        this.libraryInfo = libraryInfo;
    }

    public String getDefaultCounty() {
        return defaultCounty;
    }

    public void setDefaultCounty(String defaultCounty) {
        this.defaultCounty = defaultCounty;
    }

    public String getDefaultCurrency() {
        return defaultCurrency;
    }

    public void setDefaultCurrency(String defaultCurrency) {
        this.defaultCurrency = defaultCurrency;
    }
}
