package org.payever.app.taponphone.implementations;

import android.util.Log;

import com.mastercard.terminalsdk.emv.Tag;
import com.mastercard.terminalsdk.utility.ByteUtility;
import com.mastercard.terminalsdk.objects.PaymentData;

import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.mpos.Tags;
import org.payever.app.taponphone.utils.DataManager;

import static org.payever.app.taponphone.utils.DataManager.KEY_AMOUNT;


public class PosPaymentData extends PaymentData {

    private final static String TAG = "PosPaymentData";

    public PosPaymentData() {

        buildActivateSignalData();
    }

    private void buildActivateSignalData() {

        int fAmount = (int) (MposApplication.INSTANCE.getDataManager().getFloatData(
                KEY_AMOUNT) + 0.1);

        String newAmount = ByteUtility.byteArrayToHexString(ByteUtility.padData(ByteUtility.longToBcd(fAmount), 6, Tag.Format.n));

        Log.e(TAG, "buildActivateSignalData: Amount" + newAmount);

        super.paymentData.put(Tags.AMOUNT_AUTHORIZED_NUMERIC.getTag(), newAmount);

        String currencyCode = MposApplication.INSTANCE.getDataManager().getStringData(
                DataManager.KEY_CURRENCY);
        if (currencyCode == null) {
            super.paymentData.put(Tags.TRANSACTION_CURRENCY_CODE.getTag(),
                    DataManager.CurrencyCode.GBP.getCurrencyCode());
        } else {
            super.paymentData.put(Tags.TRANSACTION_CURRENCY_CODE.getTag(),
                    DataManager.CurrencyCode.valueOf(currencyCode).getCurrencyCode());
        }

        String transactionType = MposApplication.INSTANCE.getDataManager().getStringData(
                DataManager.KEY_TRANSACTION_TYPE);

        if (transactionType == null) {
            super.paymentData.put(Tags.TRANSACTION_TYPE.getTag(),
                    DataManager.TransactionType.PURCHASE.getTransactionTypeValue());
        } else {
            super.paymentData.put(Tags.TRANSACTION_TYPE.getTag(),
                    DataManager.TransactionType.valueOf(
                            transactionType).getTransactionTypeValue());
        }
    }
}
