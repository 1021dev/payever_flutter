package org.payever.app.taponphone.utils;

import android.content.Context;
import android.content.SharedPreferences;


public class DataManager {

    public static final String KEY_AMOUNT = "AMOUNT";
    public static final String KEY_TAGS_TO_READ = "TAGS_TO_READ";
    public static final String KEY_CURRENCY = "CURRENCY";
    public static final String KEY_COUNTRY = "COUNTRY";
    public static final String KEY_TRANSACTION_TYPE = "TRANSACTION_TYPE";
    public static final String KEY_STATUS = "STATUS";
    public static final String KEY_CURRENT_INTERFACE = "CURRENT_INTERFACE";
    public static final String KEY_ADDITIONAL_INFO = "ADDITIONAL_INFO";
    public static final String KEY_LIBRARY_INFO = "LIBRARY_INFO";
    public static final String KEY_ACTIVE_READER_PROFILE = "READER_PROFILE";
    public static final String KEY_NFC_ENABLED = "NFC_ENABLED";
    private static final String PREFERENCE_NAME = "MPOS_PREFERENCES";
    private final SharedPreferences mSharedPreferences;

    //ISO4217
    public enum CurrencyCode {
        GBP("0826", "GBP"), DOLLAR("0840", "DOLLAR"), RUPEES("0356", "RUPEES"), RENMINBI("0156", "RENMINBI");
        String mCurrencyCode;
        String mCurrency;

        /**
         * @return currency code
         */
        public String getCurrencyCode() {
            return mCurrencyCode;
        }

        /**
         * @return currency name
         */
        public String getCurrency() {
            return mCurrency;
        }

        CurrencyCode(String code, String currency) {
            mCurrencyCode = code;
            mCurrency = currency;
        }
    }

    //ISO3166-1
    public enum CountryCode {
        UK("0826", "UK"), US("0840", "US"), CHINA("0156", "CHINA"), INDIA("0356", "INDIA");

        String mCountryCode;
        String mCountryName;

        CountryCode(String code, String country) {
            mCountryCode = code;
            mCountryName = country;
        }

        /**
         * @return currency code
         */
        public String getCountryCode() {
            return mCountryCode;
        }

        /**
         * @return country name
         */
        public String getCountryName() {
            return mCountryName;
        }
    }

    public enum TransactionType {
        PURCHASE("00", "PURCHASE"), REFUND("20", "REFUND");

        String mTransactionType;
        String mTransactionTypeValue;

        public String getTransactionTypeValue() {
            return mTransactionTypeValue;
        }

        TransactionType(String transactionTypeValue, String transactionType) {
            this.mTransactionType = transactionType;
            this.mTransactionTypeValue = transactionTypeValue;
        }
    }

    public DataManager(Context context) {
        mSharedPreferences = context.getSharedPreferences(PREFERENCE_NAME, Context.MODE_PRIVATE);

        mSharedPreferences.edit().putString(KEY_ACTIVE_READER_PROFILE,
                "PPS_MChip1").apply();
        mSharedPreferences.edit().putString(KEY_TRANSACTION_TYPE,
                "PURCHASE").apply();
    }

    public SharedPreferences getPreference() {
        return mSharedPreferences;
    }

    public void saveFloatData(final String key, final float value) {
        mSharedPreferences.edit().putFloat(key, value).apply();
    }

    public void saveStringData(final String key, final String value) {
        mSharedPreferences.edit().putString(key, value).apply();
    }

    public void saveBooleanData(final String key, final boolean value) {
        mSharedPreferences.edit().putBoolean(key, value).apply();
    }

    public float getFloatData(final String key) {
        return mSharedPreferences.getFloat(key, 0);
    }

    public String getStringData(final String key) {

        return mSharedPreferences.getString(key, null);
    }

    public boolean getBooleanData(final String key) {
        return mSharedPreferences.getBoolean(key, false);
    }

}
