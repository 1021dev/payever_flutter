package org.payever.app.taponphone.api;


import android.content.Context;
import android.nfc.NfcAdapter;
import android.nfc.NfcManager;
import android.os.Environment;
import android.util.Log;

import org.payever.app.taponphone.listener.DataProvider;
import org.payever.app.taponphone.models.LogType;
import org.payever.app.taponphone.models.MposLibraryStatus;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.utils.DataManager;
import org.payever.app.taponphone.utils.FileUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.payever.app.taponphone.implementations.TransactionProcessLoggerImplementation.LOG_FOLDER_NAME;


public class SampleDataProviderImpl implements DataProvider {

    private final String TAG = "SampleDataProviderImpl";

    @Override
    public MposLibraryStatus getMposLibraryStatus(final Context context) {
        MposLibraryStatus mposLibraryStatus = new MposLibraryStatus();
        DataManager dataManager = MposApplication.INSTANCE.getDataManager();

        String status = dataManager.getStringData(DataManager.KEY_STATUS);
        if (status == null) {
            mposLibraryStatus.setStatus("Offline");
        } else {
            mposLibraryStatus.setStatus(status);
        }

        String currentInterface = dataManager.getStringData(DataManager.KEY_CURRENT_INTERFACE);
        if (currentInterface == null) {
            mposLibraryStatus.setCurrentInterface("Built in NFC");
        } else {
            mposLibraryStatus.setCurrentInterface(currentInterface);
        }

        String additionalInfo = dataManager.getStringData(DataManager.KEY_ADDITIONAL_INFO);
        if (additionalInfo == null) {
            additionalInfo = MposApplication.INSTANCE.getLibraryInfo().toString();
            dataManager.saveStringData(DataManager.KEY_ADDITIONAL_INFO,
                    additionalInfo);
            mposLibraryStatus.setAdditionalInfo(additionalInfo);
        } else {
            mposLibraryStatus.setAdditionalInfo(additionalInfo);
        }

        String libraryInfo = dataManager.getStringData(DataManager.KEY_LIBRARY_INFO);
        if (libraryInfo == null) {
            mposLibraryStatus.setLibraryInfo(MposApplication.INSTANCE.getLibraryInfo().toString());

        } else {
            mposLibraryStatus.setLibraryInfo(MposApplication.INSTANCE.getLibraryInfo().toString());
        }


        String defaultCountry = dataManager.getStringData(DataManager.KEY_COUNTRY);
        if (defaultCountry == null) {
            mposLibraryStatus.setDefaultCounty(DataManager.CountryCode.UK.getCountryName());
        } else {
            mposLibraryStatus.setDefaultCounty(defaultCountry);
        }

        String defaultCurrency = dataManager.getStringData(DataManager.KEY_CURRENCY);
        if (defaultCurrency == null) {
            mposLibraryStatus.setDefaultCurrency(DataManager.CurrencyCode.GBP.getCurrency());
        } else {
            mposLibraryStatus.setDefaultCurrency(defaultCurrency);
        }

        return mposLibraryStatus;
    }

    @Override
    public String getTransactionLogs(List<LogType> logType) {
        ArrayList<String> transactionLogsList;
        String filePath;

        for (int i = 0; i < logType.size(); i++) {

            Log.i(TAG, "logType: " + logType.get(i));
        }

        try {
            filePath = Environment.getExternalStorageDirectory().getAbsolutePath() +
                    File.separator + LOG_FOLDER_NAME + File.separator;
            String fileExtension = ".txt";

            transactionLogsList = FileUtils.loadFilesFromDir(filePath, fileExtension);

            if (transactionLogsList == null || transactionLogsList.isEmpty()) {
                return "No transaction data found";
            }

            return forTheLackOfBetterName(transactionLogsList, filePath, logType);

        } catch (FileNotFoundException e) {
            Log.e(TAG, "getTransactionLogs: MPOS Directory could not be "
                    + "found");
            return "MPOS directory not exist";
        }
    }


    private String forTheLackOfBetterName(ArrayList<String> transactionLogsList, String filePath,
                                          List<LogType> logType) {
        try {
            String transactionLogsFileName = transactionLogsList.get(0);
            return FileUtils.readFilteredDataFromLocalStorage(filePath, transactionLogsFileName,
                    logType);
        } catch (IOException ex) {
            Log.e(TAG, "getTransactionLogs: IO Exception encountered "
                    + "while accessing Transaction file");
            return "Transaction file not found";

        }
    }


    @Override
    public List<String> getCountryList() {
        List<String> countryList = new ArrayList<>();
        countryList.add(DataManager.CountryCode.UK.getCountryName());//"UK"
        countryList.add(DataManager.CountryCode.US.getCountryName());//"US"
        countryList.add(DataManager.CountryCode.INDIA.getCountryName());//"INDIA"
        countryList.add(DataManager.CountryCode.CHINA.getCountryName());//"CHINA"
        return countryList;
    }

    @Override
    public List<String> getCurrencyList() {
        List<String> currencyList = new ArrayList<>();
        currencyList.add(DataManager.CurrencyCode.GBP.getCurrency());//"EUR"
        currencyList.add(DataManager.CurrencyCode.DOLLAR.getCurrency());//"DOLLAR"
        currencyList.add(DataManager.CurrencyCode.RUPEES.getCurrency());//"RUPEES"
        currencyList.add(DataManager.CurrencyCode.RENMINBI.getCurrency());//"RENMINBI"
        return currencyList;
    }

    @Override
    public List<String> getTransactionTypeList() {
        List<String> txnTypeList = new ArrayList<>();
        txnTypeList.add("PURCHASE");
        txnTypeList.add("REFUND");
        return txnTypeList;
    }

    @Override
    public ArrayList<String> getAvailableProfiles() {
        return new ArrayList<>(MposApplication.INSTANCE.getLibraryServices().getAvailableReaderProfiles());
    }

    private boolean isNfcEnabled(Context context) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.GINGERBREAD_MR1) {
            NfcManager manager = (NfcManager) context.getSystemService(Context.NFC_SERVICE);
            NfcAdapter adapter = manager.getDefaultAdapter();
            return !(adapter != null && !adapter.isEnabled());
        }
        return false;
    }


}
