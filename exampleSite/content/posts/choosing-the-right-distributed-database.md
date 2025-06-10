---
title: "Choosing the Right Distributed Database: Balancing Consistency, Performance, and Cost"
subtitle: Navigating the tradeoffs in Distributed Databases to choose a solution that provides low-latency and strong consistency
author: Man Parvesh Singh Randhawa
date: "2024-11-03T19:04:25-08:00"
meta: true
math: false
toc: true
hideDate: false
hideReadTime: false
series: ["large-scale-distributed-systems"]
tags: [distributed-computing,distributed-database,redis]
draft: false
description: "Navigating the tradeoffs in Distributed Databases to choose a solution that provides low-latency and strong consistency"
---

In this blog post I will write about our thought process behind choosing a distributed database solution on AWS while looking for sub-millisecond latency and strong consistency.

## Our Requirements

Our requirements for this database service were as follows:
1. Sub-millisecond reads and writes: The latency metrics should be as close to an in-memory datastore as possible. 
2. Strong consistency: We required a guarantee that our clients always see the most up-to-date data.
3. Fault tolerance: This is an internal service and several of our services depend on it, so it should be able to recover from any failure conditions in network, system, etc.
4. Low or no operations cost: This is usually possible with AWS-managed services
5. Scalability: We wanted this database to be easily scalable to handle our peak loads.
6. Key-value database

### Initial thoughts based on the requirements

1. Some open-source options that fit our use case are for key-value database are: MongoDB, Redis, Cassandra, etc.
2. If we want sub-millisecond latencies, only redis or redis-based solution would fit our use-case.
3. We can deploy our own redis cluster on AWS, but that would lead to operational overhead, and it's pointless because of multiple redis-based solutions provided by AWS.

## Evaluating AWS solutions

### AWS DynamoDB

DynamoDB[^1] is an incredible key-value database solution provided by AWS. It's highly reliable and performant.

[^1]: https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf

However, it cannot compare to ultra-low latencies provided by redis-based solutions. And the linked paper mentions that DynamoDB sacrifices consistency for availability[^2], which is not good enough for our application.

[^2]: it supports eventual consistency, which is achieved using a shared transaction log service

The above shortcomings are also true for similar solutions provided by AWS, such as AWS DocumentDB (which is based on MongoDB).

### AWS Elasticache

Elasticache[^3] is another solution provided by AWS that uses Redis[^4] and promises sub-millisecond latencies for reads and writes.

[^3]: https://docs.aws.amazon.com/whitepapers/latest/scale-performance-elasticache/amazon-elasticache-overview.html
[^4]: it also provides an option to use memcached as its engine, but we focus on redis in this post

While it's an incredible option, its only (and biggest) downside is that it does not provide any guarantees on the consistency of our data. 

... and so we continue looking at other available services we can use.

### AWS MemoryDB

MemoryDB[^5] is another solution that is designed for high durability and in-memory performance. It is fully compatible with redis and provides single-digit millisecond writes and microsecond-scale read latencies, strong consistency and high durability.

[^5]: https://www.amazon.science/publications/amazon-memorydb-a-fast-and-durable-memory-first-cloud-database

The only downside for it might be its cost being slightly higher than the other solutions, but since the other solutions are unable to provide us strong consistency, we can't really use them regardless.

You know what this means.. 

🥁 We will be using **MemoryDB** for our service as it seems to be the best fit for our requirements!

## Making the decision: Why MemoryDB?

- Strong consistency: provides ACID transactions (accomplished using a distributed transaction log service)
- Low latency: Maintains Redis's renowned speed for reads, and provides single-digit writes
- Durability: Provides 11 9s of durability guarantee
- AWS-managed service: Means low operational overload and easier scaling
- **Cost Justification**: While MemoryDB is slightly pricier than its alternatives, the benefits it offers justify the additional cost.

## Conclusion

We will run load tests to derive the exact number for the provided write latency (which is supposed to be single-digit milliseconds). If it's a high number, then we might have to reconsider our design and consider sacrificing consistency and using Elasticache.

For now, we are happy that we have a seemingly viable solution for our service.
