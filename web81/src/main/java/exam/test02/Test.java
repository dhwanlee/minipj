package exam.test02;

import org.springframework.context.support.ClassPathXmlApplicationContext;


public class Test{
	public static void main(String[] args) {
		ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext("exam/test02/beans.xml");
		
		System.out.println("[컨테이너에 보관된 객체의 이름 출력]");
		
		for (String name : ctx.getBeanDefinitionNames())
		{
			System.out.println(name);
		}
		
		Score score = (Score) ctx.getBean("score");
	    System.out.println("합계"+ score.sum());
	    System.out.println("평균"+ score.average());
	}

}

