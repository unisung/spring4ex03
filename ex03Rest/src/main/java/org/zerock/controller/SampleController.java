package org.zerock.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {
      
	/* 단순 문자열 반환 시 처리*/
	@GetMapping(value="/getText", produces = "text/plain; charset=UTF-8")
	public String getText() {
          log.info("MIME TYPE: " + MediaType.TEXT_PLAIN_VALUE);	
          
          return "안녕하세요";
      }
	
	/* 사용자 정의 객체 반환*/
	@GetMapping(value="/getSample", 
			          produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,
			        		             MediaType.APPLICATION_XML_VALUE}) 
	public SampleVO getSample() {
		return new SampleVO(112, "스타","로드");
	}
	
	/*  컬렉션 타입 객체 반환*/
	@GetMapping(value="/getList", produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,
            MediaType.APPLICATION_XML_VALUE})
	public List<SampleVO> getList(){
		//return IntStream.range(1,10).mapToObj(i-> new SampleVO(i,i+"First",i+" Last")).collect(Collectors.toList());
		List<SampleVO> list=new ArrayList<SampleVO>();
		for(int i=0;i<10;i++) {
			list.add(new SampleVO(i+1,(i+1)+"First",(i+1)+" Last"));
		}
		
		return list;
	}
	
	/* 맵 객체 반환*/
	@RequestMapping("/getMap")
	public Map<String, SampleVO> getMap(){
		Map<String,SampleVO> map = new HashMap<String, SampleVO>();
		map.put("First",new SampleVO(111,"그루터", "주니어"));
		return map;
	}
	
	/* ResponseEntity 객체 반환*/
	@RequestMapping(value="/check",params= {"height","weight"})
	public ResponseEntity<SampleVO> check(Double height,Double weight){
		SampleVO vo = new SampleVO(0, ""+height, ""+weight);
		ResponseEntity<SampleVO> result=null;
		
		if(height < 150 ) {
			result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
		}else {
			result = ResponseEntity.status(HttpStatus.OK).body(vo);
		}
		return result;
	}
	
	/* RestController 의 파라미터 -1. pathvariable*/
	@GetMapping("/product/{cat}/{pid}")
	public String[] getPath(@PathVariable("cat") String cat, 
			                             @PathVariable("pid") String pid) {
		return new String[] {"category:"+cat,"product:"+pid};
	}
	
	
	/*RestController의  파라미터 -2.  JSON데이타 받기 */
	//@RequestBody에 의해 JSON 데이타가 Ticket객체로 변환 되어서 controller에 전달.
	@PostMapping("/ticket")
	public Ticket convert(@RequestBody Ticket ticket) {
		log.info("convert .......ticket"+ ticket);
		
		return ticket;
	}
	
}








