package org.payever.app.taponphone.listener;

import android.content.Context;

import org.payever.app.taponphone.models.LogType;
import org.payever.app.taponphone.models.MposLibraryStatus;

import java.util.ArrayList;
import java.util.List;

public interface DataProvider {

    /**
     * Get the current status of MPOS library
     *
     * @param context application context
     * @return Instance of {@link MposLibraryStatus}
     */
    MposLibraryStatus getMposLibraryStatus(final Context context);

    /**
     * Get the transaction logs corresponding to given {@link LogType}
     *
     * @param logType {@link LogType}
     * @return transaction logs
     */
    String getTransactionLogs(final List<LogType> logType);

    /**
     * Get the list of country
     *
     * @return country list
     */
    List<String> getCountryList();

    /**
     * Get the list of currency
     *
     * @return currency list
     */
    List<String> getCurrencyList();

    /**
     * Get the list of transaction types
     *
     * @return transaction options list
     */
    List<String> getTransactionTypeList();

    ArrayList<String> getAvailableProfiles();
}
