package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
   @GetMapping("/uploadForm")
   public void uploadForm() {
	   	log.info("upload Form");
   }
	
   
   @PostMapping("/uploadFormAction")
   public String uploadFormAction(MultipartFile[] uploadFile, Model model) {
	   String uploadFolder ="c:\\upload";
	   
	   for(MultipartFile multipartFile : uploadFile) {
		   
		     log.info("----------------------------------");
		     log.info("Upload File Name: "+multipartFile.getOriginalFilename());
		     log.info("Upload File Size: "+ multipartFile.getSize());
		     
		     File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
		     try {
		    	   multipartFile.transferTo(saveFile);
		     }catch(Exception e) {
		    	 log.error(e.getMessage());
		     }
	   }
	   
	   return "redirect:/uploadForm";
   }
   
   @GetMapping("/uploadAjax")
	   public void uploadAjax() {
		   log.info("upload ajax");
	   }
   
   ///
   @PostMapping(value="/uploadAjaxAction",
		                  produces= {MediaType.APPLICATION_JSON_UTF8_VALUE})
@ResponseBody
public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
	   log.info("upload ajax post.......");
	   
	   List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();
	   AttachFileDTO attachDTO = new AttachFileDTO(); 
	   String uploadFolder ="c:\\upload";
	   String uploadFolderPath=getFolder();// 2020-09-22
	   
	// make folder --------
	    File uploadPath = new File(uploadFolder, uploadFolderPath);//c:\\upload\\2020-09-22
	    log.info("upload path: " + uploadPath);

	   //파일저장 경로 생성
	     if(!uploadPath.exists()) uploadPath.mkdirs();
	    
	     
	   for(MultipartFile multipartFile : uploadFile) {
		   
		     log.info("----------------------------------");
		     log.info("Upload File Name: "+multipartFile.getOriginalFilename());
		     log.info("Upload File Size: "+ multipartFile.getSize());
		     
		     
		     UUID uuid =UUID.randomUUID();
		     log.info(uuid);
		     
String upLoadFileName=multipartFile.getOriginalFilename();
		     
upLoadFileName
           =upLoadFileName.substring(upLoadFileName.lastIndexOf("\\")+1);		 
		     
attachDTO.setFileName(multipartFile.getOriginalFilename());//파일명 		

upLoadFileName =uuid.toString()+"_"+multipartFile.getOriginalFilename();

		     File saveFile = new File(uploadPath, upLoadFileName);
		     		     
		     log.info(saveFile.getAbsolutePath());
		     try {
		    	    
		    	   multipartFile.transferTo(saveFile);
		    	   
	    		   
	    		   attachDTO.setUuid(uuid.toString());//uuid
	    		   attachDTO.setUploadPath(uploadFolderPath);//저장경로
	    		   
		    	   //thumbnail로 저장
		    	   if(checkImageType(saveFile)) {
		    		   
		    		   attachDTO.setImage(true);//이미지 여부
		    		   FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_"+upLoadFileName));
		    		   Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
		    		   thumbnail.close();
		    	   }
		    	   
		    	   list.add(attachDTO);
		     }catch(Exception e) {
		    	 log.error(e.getMessage());
		     }
	   }
	   
	   return new ResponseEntity<>(list, HttpStatus.OK);
   }
   
   @GetMapping("/display")
   public ResponseEntity<byte[]> getFile(String fileName) throws UnsupportedEncodingException{
	   log.info("fileName: " + fileName);
	   
	   log.info(URLDecoder.decode(fileName,"UTF-8"));
	   File file = new File("c:\\upload\\"+fileName);
	   
	   log.info("file: " + file);
	   
	   ResponseEntity<byte[]> result = null;
	   
	   try {
		   		HttpHeaders header = new HttpHeaders();
		   		
		   		header.add("Content-Type", Files.probeContentType(file.toPath()));//MIME타입 
		   		result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);//
		   
	   }catch(Exception e) {
		   e.printStackTrace();
	   }
	   return result;
   }
   
   private String getFolder() {
	   
	   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	   
	   Date date = new Date();
	   
	   String str = sdf.format(date);
	   
	   return str.replace("-", File.separator);
   }

   //전송된 파일의 타입(image인지 아닌지여부확인 메소드) 
   private boolean checkImageType(File file) {
	   try {
		   		
		    String contentType = Files.probeContentType(file.toPath());
		    return contentType.startsWith("image");
	   }catch(Exception e) {
		   e.printStackTrace();
	   }
	   return false;
   }
   
}