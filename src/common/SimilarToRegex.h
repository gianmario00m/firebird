/*
 *  The contents of this file are subject to the Initial
 *  Developer's Public License Version 1.0 (the "License");
 *  you may not use this file except in compliance with the
 *  License. You may obtain a copy of the License at
 *  http://www.ibphoenix.com/main.nfs?a=ibphoenix&page=ibp_idpl.
 *
 *  Software distributed under the License is distributed AS IS,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied.
 *  See the License for the specific language governing rights
 *  and limitations under the License.
 *
 *  The Original Code was created by Adriano dos Santos Fernandes
 *  for the Firebird Open Source RDBMS project.
 *
 *  Copyright (c) 2019 Adriano dos Santos Fernandes <adrianosf at gmail.com>
 *  and all contributors signed below.
 *
 */

#ifndef FB_COMMON_SIMILAR_TO_REGEX_H
#define FB_COMMON_SIMILAR_TO_REGEX_H

#include "firebird.h"
#include <re2/re2.h>
#include "../common/classes/auto.h"
#include "../common/classes/array.h"
#include "../common/classes/fb_string.h"

namespace Firebird {


//// FIXME: Leak re2::RE2 when destroyed by pool.
class SimilarToRegex : public PermanentStorage
{
public:
	struct MatchPos
	{
		unsigned start;
		unsigned length;
	};

public:
	SimilarToRegex(MemoryPool& pool, bool caseInsensitive,
		const char* patternStr, unsigned patternLen, const char* escapeStr, unsigned escapeLen);

public:
	bool matches(const char* buffer, unsigned bufferLen, Array<MatchPos>* matchPosArray = nullptr);

private:
	AutoPtr<re2::RE2> regexp;
};

//// FIXME: Leak re2::RE2 when destroyed by pool.
// Given a regular expression R1<escape>#R2#<escape>R3 and the string S:
// - Find the shortest substring of S that matches R1 while the remainder (S23) matches R2R3;
// - Find the longest (S2) substring of S23 that matches R2 while the remainder matches R3;
// - Return S2.
class SubstringSimilarRegex : public PermanentStorage
{
public:
	SubstringSimilarRegex(MemoryPool& pool, bool caseInsensitive,
		const char* patternStr, unsigned patternLen, const char* escapeStr, unsigned escapeLen);

public:
	bool matches(const char* buffer, unsigned bufferLen, unsigned* resultStart, unsigned* resultLength);

private:
	AutoPtr<re2::RE2> regexp;
};


}	// namespace Firebird

#endif	// FB_COMMON_SIMILAR_TO_REGEX_H