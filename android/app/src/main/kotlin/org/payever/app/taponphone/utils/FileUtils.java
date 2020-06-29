package org.payever.app.taponphone.utils;

import android.os.Environment;
import android.util.Log;


import org.payever.app.taponphone.models.LogType;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static android.content.ContentValues.TAG;


public class FileUtils {

    private static BufferedWriter mLogWriter;

    private FileUtils() {

    }

    /**
     * Listing out all the required file(s) in a specific directory.
     *
     * @param dir      Absolute path of directory containing files.
     * @param fileType Extension of file to be listed.
     * @return List of file name of desired extension.
     * @throws FileNotFoundException if given directory or file not exist
     */
    public static ArrayList<String> loadFilesFromDir(String dir,
                                                     final String fileType)
            throws FileNotFoundException {
        File mPath = new File(dir);
        String[] list;
        if (mPath.exists()) {
            FilenameFilter filter = new FilenameFilter() {
                @Override
                public boolean accept(File dir, String filename) {
                    return filename.endsWith(fileType);
                }
            };
            list = mPath.list(filter);
        } else {
            throw new FileNotFoundException();
        }
        return new ArrayList<>(Arrays.asList(list));
    }

    /**
     * Reads Json from given file.
     *
     * @param filePath Directory absolute path
     * @param fileName file name in specified directory
     * @return Json string from specified file.
     * @throws IOException If directory or file not available.
     */
    public static String readDataFromLocalStorage(String filePath, String fileName)
            throws IOException {
        //Get the text file
        File file = new File(filePath, fileName);

        //Read text from file
        StringBuilder text = new StringBuilder();

        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;

        while ((line = br.readLine()) != null) {
            text.append(line + "\n");
        }
        br.close();
        return new String(text);
    }

    public static void createDirectory(String rootPath) {
        if (isExternalStorageWritable()) {
            final File mRootFolder = new File(rootPath);
            if (!mRootFolder.exists() && !mRootFolder.mkdirs()) {
                Log.e(TAG, "createDirectory: Unable to create the root folder");
            }
        } else {
            Log.e(TAG, "createDirectory: SD Card not available for read and write");
        }

    }

    /**
     * Checks if external storage is available for read and write
     */
    private static boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        return Environment.MEDIA_MOUNTED.equals(state);
    }


    public static String readFilteredDataFromLocalStorage(String filePath, String fileName,
                                                          List<LogType> logType)
            throws IOException {

        if (logType == null || logType.isEmpty()) {
            return readDataFromLocalStorage(filePath, fileName);
        }
        //Get the text file
        File file = new File(filePath, fileName);

        //Read text from file
        StringBuilder text = new StringBuilder();

        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;

        while ((line = br.readLine()) != null) {
            if (line.contains("MPOS") || isConditionSatisfied(line, logType)) {
                text.append(line);
                text.append("\n");
            }
        }
        br.close();
        return new String(text);
    }

    private static boolean isConditionSatisfied(String line, List<LogType> logType) {
        for (int i = 0; i < logType.size(); i++) {
            if (line.contains(logType.get(i).getLogType())) {
                return true;
            }
        }
        return false;
    }

    /**
     * Writes data to the log file
     *
     * @param typeOfData     Type of data to be logged
     * @param dataToBeLogged Data to be logged
     */
    public static void logDataToFile(String typeOfData, String dataToBeLogged) {
        try {
            mLogWriter.append(typeOfData);
            mLogWriter.append(" : ");
            mLogWriter.append(dataToBeLogged);
            mLogWriter.newLine();
            mLogWriter.flush();

        } catch (IOException e) {
            Log.e(TAG, "IOException was encountered: ", e.getCause());
            try {
                mLogWriter.close();
            } catch (IOException er) {
                Log.e(TAG, "IOException was encountered while closing Log writer: ", er.getCause());
            }
        }
    }

    public static void logDataToFileAppend(String typeOfData, String dataToBeLogged) {
        try {

            mLogWriter.append(typeOfData);
            mLogWriter.append(" : ");
            mLogWriter.append(dataToBeLogged);
            mLogWriter.flush();

        } catch (IOException e) {
            Log.e(TAG, "IOException was encountered: ", e.getCause());
            try {
                mLogWriter.close();
            } catch (IOException er) {
                Log.e(TAG, "IOException was encountered while closing Log writer: ", er.getCause());
            }
        }
    }

    public static void closeFileWriter() {
        try {
            Log.d("", "closeFileWriter: ");
            mLogWriter.close();
        } catch (IOException e) {
            Log.e(TAG, "IOException was thrown while closing File Writer: ", e.getCause());
        }
    }

    public static void createLogWriter(File mPosLog) {
        try {
            mLogWriter = new BufferedWriter(new FileWriter(mPosLog, false));
        } catch (IOException e) {
            Log.e(TAG, "IOException was encounterd while creating File writer: ", e.getCause());
        }
    }

    public static void startLoggingToFile(String typeOfData, String dataToBeLogged) {
        try {
            mLogWriter.write(typeOfData + " : " + dataToBeLogged);
            mLogWriter.newLine();
            mLogWriter.flush();
        } catch (IOException e) {
            Log.e(TAG, "IOException encountered while logging to file: ", e.getCause());
        }
    }
}
