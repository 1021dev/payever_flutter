package org.payever.app.taponphone.implementations;

import android.util.Log;

import com.mastercard.terminalsdk.listeners.TransactionOutcomeObserver;
import com.mastercard.terminalsdk.objects.ErrorIndication;
import com.mastercard.terminalsdk.objects.ReaderOutcome;

import org.payever.app.taponphone.listener.TransactionListener;
import org.payever.app.taponphone.mpos.MposApplication;

public class OutcomeObserver implements TransactionOutcomeObserver {

    private static final String TAG = "OutcomeObserver";

    private ReaderOutcome mTransactionOutcome;

    private TransactionListener mTransactionListenerForUI;


    @Override
    public void transactionOutcome(final ReaderOutcome readerOutcome) {
        mTransactionOutcome = readerOutcome;
        Log.i(TAG, "Transaction Summary : " + mTransactionOutcome.toString());


        logOutcome(readerOutcome);

        // Process the outcome Returned from Library
        processOutcome();
    }

    private void logOutcome(ReaderOutcome readerOutcome) {

        MposApplication.INSTANCE.getTransactionProcessLogger().logInfo("\nReceived Outcome :");
    }

    private void processOutcome() {

        //status Approved and Online - considered as Success

        if (mTransactionListenerForUI != null) {
            switch (mTransactionOutcome.getOutcomeParameterSet().getStatus()) {

                case APPROVED:
                    mTransactionListenerForUI.onTransactionSuccessful();
                    break;
                case ONLINE_REQUEST:
                    mTransactionListenerForUI.onOnlineReferral();
                    break;
                case DECLINED:
                    mTransactionListenerForUI.onTransactionDeclined();
                    break;
                case END_APPLICATION:
                    ErrorIndication errorIndication = mTransactionOutcome.getDiscretionaryData().getErrorIndication();
                    if (errorIndication.getL3Error() == ErrorIndication.L3_Error_Code.STOP)
                        mTransactionListenerForUI.onTransactionCancelled();
                    else
                        mTransactionListenerForUI.onApplicationEnded();

                    break;
                default:
                    mTransactionListenerForUI.onApplicationEnded();
            }
        }
    }

    public void resetObserver(TransactionListener transactionListenerForUI) {
        mTransactionOutcome = null;
        mTransactionListenerForUI = transactionListenerForUI;
    }
}
