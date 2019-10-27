#include "pch.h"



extern "C" {
#include "dummy.h"
#include "driver.h"
}

TEST(TestCaseName1, TestName) {
	EXPECT_EQ(5, add(1,3));
	EXPECT_TRUE(false) << ("sum: " + std::to_string(sum) );
	//EXPECT_TRUE(true);
}

TEST(TestCaseName2, TestName) {
	add(1, 3);
	EXPECT_EQ(4, sum);
	//EXPECT_TRUE(true);
}

TEST(TestCaseName3, TestName) {
	EXPECT_EQ(4, add(1, 3));
	//EXPECT_TRUE(true);
}

TEST(TestCaseName4, TestName) {
	EXPECT_EQ(5, add(22, 3));
	//EXPECT_TRUE(true);
}