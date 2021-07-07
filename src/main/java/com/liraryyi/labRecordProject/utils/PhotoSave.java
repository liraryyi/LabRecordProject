package com.liraryyi.labRecordProject.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;

public class PhotoSave {
    /**
     * 将Base64位编码的图片进行解码，并保存到指定目录
     */
    public static void decodeBase64DataURLToImage(String dataURL, String path, String imgName) throws IOException {
        // 将dataURL开头的非base64字符删除
        String base64 = dataURL.substring(dataURL.indexOf(",") + 1);
        FileOutputStream write = new FileOutputStream(new File(path + imgName));
        byte[] decoderBytes = Base64.getDecoder().decode(base64);
        write.write(decoderBytes);
        write.close();
    }
}
