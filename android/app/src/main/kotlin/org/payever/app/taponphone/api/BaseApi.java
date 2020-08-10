package org.payever.app.taponphone.api;

import android.util.Log;

import com.mastercard.terminalsdk.exception.*;
import com.mastercard.terminalsdk.listeners.TransactionProcessLogger;

import org.payever.app.taponphone.implementations.PosPaymentData;
import org.payever.app.taponphone.listener.TransactionListener;
import org.payever.app.taponphone.mpos.BrandIdentifier;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.mpos.PaymentNetwork;

import static android.content.ContentValues.TAG;

public class BaseApi {

    private BaseApi() {

    }

    /**
     * Start a new transaction
     *
     * @param transactionListener transaction result callback
     */
    public static void performTransaction(final TransactionListener transactionListener) {

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {

                    TransactionProcessLogger loggerImpl = MposApplication.INSTANCE.getTransactionProcessLogger();
                    BrandIdentifier brandIdentifier = new BrandIdentifier(MposApplication.INSTANCE.getNfcProvider(), loggerImpl);
                    PaymentNetwork pymntNw = brandIdentifier.identifyPaymentNetwork();
                    switch (pymntNw) {
                        case MASTERCARD:
                            loggerImpl.logInfo("Invoking Mastercard SDK");
                            MposApplication.INSTANCE.getTransactionApi().proceedWithMastercardTransaction(
                                    new PosPaymentData(), brandIdentifier.getPpseResponse());
                            break;
                        case MASTERCARD_QPBOC:
                            loggerImpl.logInfo("Invoking Mastercard SDK");
                            MposApplication.INSTANCE.getTransactionApi().proceedWithMastercardTransaction(
                                    new PosPaymentData(), brandIdentifier.getPpseResponse());
                            break;
                        default:
                            loggerImpl.logWarning("Unsupported Payment Network: " + pymntNw);
                            BaseApi.abortTransaction(transactionListener);

                    }
                } catch (ReaderBusyException e) {
                    Log.e(TAG, "SDK is busy with another transaction, please wait");
                } catch (Exception er) {
                    Log.e(TAG, "run: ", er.getCause());
                    transactionListener.onTransactionCancelled();
                }
            }
        }

        ).start();
    }

    public static void abortTransaction(final TransactionListener transactionListener) {

        try {
            MposApplication.INSTANCE.getTransactionApi().abortTransaction();
        } catch (Exception er) {
            Log.e(TAG, "run: ", er.getCause());
            transactionListener.onTransactionCancelled();
        }
    }
}
