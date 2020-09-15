package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor//모든 매개변수 생성자
@NoArgsConstructor//기본 생성자
public class SampleVO {
	
	private Integer mno;
	private String firstName;
	private String lastName;

}
