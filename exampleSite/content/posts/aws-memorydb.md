---
title: "Paper Summary: AWS MemoryDB"
subtitle: Summary of the scientific paper on AWS MemoryDB
author: Man Parvesh Singh Randhawa
date: "2024-11-04T21:39:14-08:00"
meta: true
math: true
toc: false
hideDate: false
hideReadTime: false
series: [paper-summaries]
tags: [distributed-database,redis]
draft: false
description: ""
---

**Abstract**: Amazon MemoryDB for Redis is a database service designed for
11 9s of durability with in-memory performance. In this paper, we
describe the architecture of MemoryDB and how we leverage opensource Redis, a popular data structure store, to build an enterprise grade cloud database. MemoryDB offloads durability concerns to
a separate low-latency, durable transaction log service, allowing
us to scale performance, availability, and durability independently
from the in-memory execution engine. We describe how, using this
architecture, we are able to remain fully compatible with Redis,
while providing single-digit millisecond write and microsecondscale read latencies, strong consistency, and high availability. MemoryDB launched in 2021.

Paper link: https://www.amazon.science/publications/amazon-memorydb-a-fast-and-durable-memory-first-cloud-database

## 1. Origin Story

For several applications that require fast response time, we use in-memory databases like Redis. AWS provides AWS Elasticache that runs redis, but it does not provide any guarantees for durability and consistency. So several AWS customers had to build their own complex pipelines to handle data loss in case of any failures.

MemoryDB was built to provide in-memory performance with durability, strong consistency, and high availability

## 2. Redis Arhitecture and Limitations

### 2.1. Architecture

Redis allows horizontal scaling and splits its key space into 16384 slots that are distributed across one or more shards as a part of the server setup. Each shard has a single primary and zero or more read-only replicas.

Discovering lock-to-shard mapping is implemented inside client logic.

Replication between primary and replica nodes is implemented as a passive logical replication{{<sidenote>}}a.k.a. eventually consistent{{</sidenote>}}.

Another limitation in this architecture is that it doesn't allow all commands to be naively forwarded to replicas - commands that include some degree of randomization - like SPOP.

### 2.2. Challenges of Maintaining Durability and Consistency

During a failover scenario: Redis uses quorum-based approach for failure detection and new primary election. After a failover, a new primary can be elected within seconds, but the new primary might not have the most up-to-date data - because of async updates to this replica.

Redis implements a few mechanisms for lightweight persistence:
point-in-time snapshots, and an on-disk transaction log.

## 3. Achieving Durability and Consistency

A durable database system must ensure that once data is committed and acknowledged it can be read back. MemoryDB offloads durability by leveraging a distributed transaction log service. A transaction log provides low-latency and strongly consistent
commits across multiple AZs.

### 3.1. Decoupling Durability

Each shard in MemoryDB uses passive replication, where a primary replicates the mutative commands it executes to its transaction log. Specifically, MemoryDB intercepts the Redis replication
stream, chunks it into records, and sends each record to the transaction log. The replicas read the replication stream sequentially
from the transaction log and stream it into Redis. As a result, every
replica holds an eventually consistent copy of the data set.

### 3.2. Maintaining Consistency

MemoryDB provides linearizability by making propagation to the multi-AZ transaction log
synchronous. It follows the write-behind logging principle, which replicates the effects of the executed command instead of the original command.

Due to our choice of using passive replication, mutations are
executed on a primary node before being committed into the transaction log. If a commit fails, for example due to network isolation,
the change must not be acknowledged and must not become visible.

MemoryDB adds a layer of client blocking. After a client sends a mutation, the
reply from the mutation operation is stored in a tracker until the
transaction log acknowledges persistence and only then sent to the
client. Meanwhile, the Redis workloop can process other operations.
Non-mutating operations can be executed immediately but must
consult the tracker to determine if their results must also be delayed
until a particular log write completes. Hazards are detected at the
key level.

## 4. Availability, Recovery and Resilience

### 4.1. Leader Election

### 4.2. Recovery

## 5. Management Operations

### 5.1. Cluster Management

### 5.2. Scaling

## 6. Evaluation

## 7. Validating and Maintaining Consistency at Scale

### 7.1. Consistency During Upgrades

### 7.2. Verifying Correctness

## 8. Related work

### 8.1. Disaggregated databases

### 8.2. Log-based Replication

### 8.3. In-memory databases

## 9. Conclusion