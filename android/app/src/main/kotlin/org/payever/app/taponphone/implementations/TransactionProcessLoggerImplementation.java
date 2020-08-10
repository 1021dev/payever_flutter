package org.payever.app.taponphone.implementations;

import android.os.Environment;
import android.util.Log;
import com.mastercard.terminalsdk.listeners.TransactionProcessLogger;

import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.utils.FileUtils;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import static org.payever.app.taponphone.utils.FileUtils.createDirectory;

public class TransactionProcessLoggerImplementation implements TransactionProcessLogger {

    private static File mPosLog;

    public static final String LOG_FOLDER_NAME = "MPOS";

    /**
     * Get the log file, (creates it , if not existing) logs the date and time
     */
    public TransactionProcessLoggerImplementation() {

        String filePath = Environment.getExternalStorageDirectory().getAbsolutePath() +
                File.separator + LOG_FOLDER_NAME + File.separator + "log.txt";
        mPosLog = new File(filePath);
        try {
            if (!mPosLog.exists()) {
                createDirectory(Environment.getExternalStorageDirectory().getAbsolutePath() +
                        File.separator + LOG_FOLDER_NAME);
                mPosLog.createNewFile();
            }

            FileUtils.createLogWriter(mPosLog);

            String formattedDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());
            FileUtils.startLoggingToFile("mPos started ", formattedDate);


        } catch (IOException e) {
            MposApplication.INSTANCE.getTransactionProcessLogger().logError(e.getMessage());
        }
    }

    @Override
    public void logCryptoOperations(String cryptoMessages) {
        Log.d("DEBUG", cryptoMessages);
        FileUtils.logDataToFile("DEBUG", cryptoMessages);
    }

    @Override
    public void logInternalOperation(String functions) {
        Log.d("DEBUG", functions);
        FileUtils.logDataToFile("DEBUG", functions);

    }

    @Override
    public void logDebug(String debugData) {
        Log.d("DEBUG", debugData);
        FileUtils.logDataToFile("DEBUG", debugData);
    }

    @Override
    public void logInfo(String infoLogData) {
        Log.i("INFO", infoLogData);
        FileUtils.logDataToFile("INFO", infoLogData);
    }

    @Override
    public void logWarning(String warningData) {
        Log.w("WARNING", warningData);
        FileUtils.logDataToFile("WARNING", warningData);
    }

    @Override
    public void logError(String errorData) {
        Log.e("ERROR", errorData);
        FileUtils.logDataToFile("ERROR", errorData);
    }

    @Override
    public void logApduExchange(String apdus) {

        Log.d("", apdus);
        FileUtils.logDataToFile("DEBUG", apdus);
    }

    @Override
    public void logTlvParsing(String parsedTLV) {

        Log.d("", parsedTLV);
        FileUtils.logDataToFileAppend("DEBUG", parsedTLV);
    }

    public void closeFileWriter() {
        FileUtils.closeFileWriter();
    }

}
