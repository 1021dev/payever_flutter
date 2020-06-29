package org.payever.app.taponphone.mpos;


import android.util.Log;

import com.mastercard.terminalsdk.listeners.TransactionProcessLogger;
import com.mastercard.terminalsdk.objects.ContentType;
import com.mastercard.terminalsdk.utility.TLVUtility;
import com.mastercard.terminalsdk.exception.L1RSPException;
import com.mastercard.terminalsdk.exception.LibraryCheckedException;
import com.mastercard.terminalsdk.exception.LibraryUncheckedException;
import com.mastercard.terminalsdk.iso8825.BerTlv;
import com.mastercard.terminalsdk.listeners.CardCommunicationProvider;
import com.mastercard.terminalsdk.utility.ByteUtility;

import org.payever.app.taponphone.implementations.nfc.NfcProvider;

import java.util.Arrays;

public class BrandIdentifier {

    private static final String TAG = "BrandIdentifier ";

    private CardCommunicationProvider mCardComms;
    private TransactionProcessLogger mLoggerImplementation;

    private byte[] mPpseResponse;

    public BrandIdentifier(NfcProvider cardCcmms, TransactionProcessLogger loggerImplementation) {

        mCardComms = cardCcmms;
        mLoggerImplementation = loggerImplementation;
    }

    public PaymentNetwork identifyPaymentNetwork() {

        mPpseResponse = new byte[0];
        try {
            mCardComms.disconnectReader();

            mCardComms.connectReader();

            mCardComms.connectCard();

            mLoggerImplementation.logInfo(TAG + "Sending PPSE command");
            String ppseCommand = "00A404000E325041592E5359532E444446303100";
            byte[] commandBytes = ByteUtility.hexStringToByteArray(ppseCommand);
            mLoggerImplementation.logApduExchange("CMD>> " + ppseCommand);
            mPpseResponse = mCardComms.sendReceive(commandBytes);
            mLoggerImplementation.logApduExchange("RSP<< " + ByteUtility.byteArrayToHexString(mPpseResponse));

            if (mPpseResponse != null && isSuccess(mPpseResponse)) {
                BerTlv adfTlv = TLVUtility.extractTLV(mPpseResponse, Tags.ADF_NAME.getTagBytes(), ContentType.TLV);
                byte[] rid = extractRid(adfTlv.getBytes());
                PaymentNetwork identifiedNetwork = PaymentNetwork.get(ByteUtility.byteArrayToHexString(rid));
                mLoggerImplementation.logInfo(TAG + "Identified Payment network " + identifiedNetwork.name());
                return identifiedNetwork;
            }
        } catch (L1RSPException l1rsp) {
            Log.e(TAG, "L1RSP Exception:" + l1rsp.getMessage());
        } catch (LibraryCheckedException | LibraryUncheckedException luce) {
            Log.e(TAG, "LibraryCheckedException:" + luce.getMessage());
        }

        return PaymentNetwork.UNKNOWN;
    }

    private boolean isSuccess(byte[] responseBytes) {
        // copy status word
        if (responseBytes.length > 2) {
            byte[] statusWord = new byte[]{responseBytes[responseBytes.length - 2],
                    responseBytes[responseBytes.length - 1]};
            return (statusWord[0] & 0x00FF) == 0x0090 && statusWord[1] == 0x00;
        }
        return false;
    }

    private byte[] extractRid(byte[] aid) {

        if (aid.length < 5) {
            return new byte[0];
        }
        return Arrays.copyOfRange(aid, 0, 5);
    }

    public byte[] getPpseResponse() {
        return mPpseResponse;
    }
}
